module "development" {
  depends_on = [aws_internet_gateway.this]
  source     = "./modules/environment"

  az = local.default_availability_zone

  env_name       = "dev"
  env_short_name = "dev"

  subnet_id          = aws_subnet.a.id
  security_group_ids = [aws_security_group.base.id]

  ami_id                    = coalesce(var.ami_id, data.aws_ami.ubuntu.id)
  iam_instance_profile_name = aws_iam_instance_profile.ec2-app-service.name

  root_block_device_size_gibs = 25

  keypair_name = aws_key_pair.primary-ssh-key.key_name

  digitalocean_domain_id = data.digitalocean_domain.this.id

  admin_username  = "ubuntu"
  admin_usergroup = "ubuntu"

  certbot_email = var.primary_email_contact

  project = var.project
  project_name = var.project_name

  database = {
    has_database           = false
    subnet_group_name      = aws_db_subnet_group.this.name
    vpc_security_group_ids = [aws_security_group.base.id]
  }

  // TODO: Maybe move all of the value into a local variable defined in `github.tf`?
  github_action_build_map = {
    (local.github_repository_names.frontend) = [
      {
        name  = "BUILD_BRANCH"
        value = "develop"
      },
      {
        name  = "IMAGE_TAG"
        value = "dev"
      },
      {
        name  = "IMAGE_NAME"
        value = "frontend"
      },
      {
        name  = "TARGET_ENV"
        value = "docker/dev/.env"
      },
      {
        name  = "TARGET_DOCKERFILE"
        value = "docker/dev/Dockerfile"
      },
    ],
    (local.github_repository_names.backend) = [
      {
        name  = "BUILD_BRANCH"
        value = "develop"
      },
      {
        name  = "IMAGE_TAG"
        value = "dev"
      },
      {
        name  = "IMAGE_NAME"
        value = "backend"
      },
      {
        name  = "TARGET_DOCKERFILE"
        value = "docker/dev/Dockerfile"
      },
    ]
  }
}

output "development" {
  value = module.development

  sensitive = true
}
