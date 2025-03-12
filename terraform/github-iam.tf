# TODO: keep until there is a programmatic way to do:
# 1. there is a way we can determine if the GitHub IdP exists, create the necessary resource if not set and reference its ARN with a variable
# 2. get the thumbprint of the IdP as `thumbprint_list` cannot empty!

# resource "aws_iam_openid_connect_provider" "github" {
#   url = local.github_identity_provider

#   client_id_list = [
#     "sts.amazonaws.com",
#   ]

#   // Hit https://us-east-1.console.aws.amazon.com/iam/home?region=ap-southeast-2#/identity_providers/create with the above parameters and you'll get a thumbprint
#   // Further reading:
#   // - https://github.com/hashicorp/terraform-provider-aws/issues/10104
#   // - https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html
#   // TODO: automate retrieval of thumbprint
#   thumbprint_list = ["1b511abead59c6ce207077c0bf0e0043b1382612"]
# }

locals {
  repository_subject_products = [
    for repository in local.github_repository_names : "repo:${var.github_owner}/${repository}:*"
  ]

  # IDP, IdP = Identity Provider
  github_idp         = "token.actions.githubusercontent.com"
  iam_github_idp_arn = data.aws_iam_openid_connect_provider.github.arn
}

// Allow pushing to ECR (TODO: need to narrow down policy)
data "aws_iam_policy" "AmazonEC2ContainerRegistryPowerUser" {
  name = "AmazonEC2ContainerRegistryPowerUser"
}

// Allow entity to send SSM commands (ssm:SendCommand)
// TODO: don't agree with AmazonSSMMaintenanceWindowRole at all. Investigate why AmazonSSMServiceRolePolicy does not work ("PolicyNotAttachable: Cannot attach a Service Role Policy to a Customer Role")
data "aws_iam_policy" "AmazonSSMMaintenanceWindowRole" {
  name = "AmazonSSMMaintenanceWindowRole"
}

// TODO: Test what happens if the IdP does not exist. Handle accordingly if it has to be retrieved or created. EDIT: it doesn't seem easy to handle. So, manual it is :|
data "aws_iam_openid_connect_provider" "github" {
  url = "https://${local.github_idp}"
}

// Reference: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-idp_oidc.html#idp_oidc_Create_GitHub
resource "aws_iam_role" "github-actions" {
  name = "GitHubActions-${var.project}"

  assume_role_policy = data.aws_iam_policy_document.github_federated_identity.json

  # What [managed] permission policy should we grant to the scope defined in `assume_role_policy`?
  managed_policy_arns = [
    data.aws_iam_policy.AmazonEC2ContainerRegistryPowerUser.arn,
    data.aws_iam_policy.AmazonSSMMaintenanceWindowRole.arn
  ]
}

data "aws_iam_policy_document" "github_federated_identity" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [local.iam_github_idp_arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${local.github_idp}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "${local.github_idp}:sub"
      values   = local.repository_subject_products
    }
  }
}