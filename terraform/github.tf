provider "github" {
  owner = var.github_owner
}

locals {
  github_repository_names = {
    backend = "district32-backend"
    frontend = "district32-frontend"
  }

  github_action_variables = [
    {
      name  = "PROJECT_NAMESPACE"
      value = var.project_name
    },
    {
      name  = "AWS_REGION"
      value = var.region
    },
    {
      name  = "AWS_ROLE_ARN"
      value = aws_iam_role.github-actions.arn
    },
    {
      name  = "AWS_SSM_DOCUMENT_NAME"
      value = aws_ssm_document.docker-compose-up.name
    }
  ]

  github_repository_variables = {
    (local.github_repository_names.frontend) = [
      {
        name  = "AWS_ECR_URL"
        value = module.frontend_registry.repository_url
      }
    ],
    (local.github_repository_names.backend) = [
      {
        name  = "AWS_ECR_URL"
        value = module.backend_registry.repository_url
      }
    ]
  }

  shared_repository_variable_products = [
    for val in setproduct([for product in local.github_repository_names : product], [for product in local.github_action_variables : product]) : {
      repository = val[0]
      name       = val[1].name
      value      = val[1].value
    }
  ]

  repository_variable_products = flatten([
    for repository, variables in local.github_repository_variables : [
      for variable in variables : {
        repository = repository,
        name       = variable.name,
        value      = variable.value
      }
    ]
  ])
}

resource "github_actions_variable" "this" {
  for_each = tomap({
    for value in concat(local.shared_repository_variable_products, local.repository_variable_products) : "${value.repository}.${value.name}" => value
  })

  repository    = each.value.repository
  variable_name = each.value.name
  value         = each.value.value
}
