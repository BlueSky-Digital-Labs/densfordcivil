# IAM Role for our compute resources

resource "aws_iam_role" "ec2-app-service" {
  name = "EC2AppService-${var.project}"

  # In console, this is the Trust Relationships/Trusted Entities.
  # The interpretation are as follows:
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"       # Entity can assume a role
        Effect = "Allow"                # Allow the action (Action) defined (or reject if set)
        Principal = {                   # List of entities that are covered by this declaration
          Service = "ec2.amazonaws.com" # Service = refers to AWS services. In this case, we let EC2 (ec2.amazonaws.com) assume this role. 
        }
      },
    ]
  })

  # What [managed] permission policy should we grant to the scope defined in `assume_role_policy`?
  managed_policy_arns = [
    data.aws_iam_policy.AmazonEC2ContainerRegistryReadOnly.arn,
    data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn
  ]
}

resource "aws_iam_instance_profile" "ec2-app-service" {
  name = "${var.project}-${aws_iam_role.ec2-app-service.name}"
  role = aws_iam_role.ec2-app-service.name
}

# For the compute instance to be able to pull ECR images
data "aws_iam_policy" "AmazonEC2ContainerRegistryReadOnly" {
  name = "AmazonEC2ContainerRegistryReadOnly"
}

# And so AWS Systems Manager can run commands in the instance dispatched from elsewhere
data "aws_iam_policy" "AmazonSSMManagedInstanceCore" {
  name = "AmazonSSMManagedInstanceCore"
}