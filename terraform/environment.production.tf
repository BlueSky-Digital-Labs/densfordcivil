module "production" {
 depends_on = [aws_internet_gateway.this]
 source     = "./modules/environment"

 az = local.default_availability_zone

 env_name       = "production"
 env_short_name = "prod"

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

 github_action_build_map = {
   (local.github_repository_names.frontend) = [
     {
       name  = "BUILD_BRANCH"
       value = "main"
     },
     {
       name  = "IMAGE_TAG"
       value = "latest"
     },
     {
       name  = "IMAGE_NAME"
       value = "frontend"
     },
     {
       name  = "TARGET_ENV"
       value = "docker/prod/.env"
     },
     {
       name  = "TARGET_DOCKERFILE"
       value = "docker/prod/Dockerfile"
     },
   ],
   (local.github_repository_names.backend) = [
     {
       name  = "BUILD_BRANCH"
       value = "main"
     },
     {
       name  = "IMAGE_TAG"
       value = "latest"
     },
     {
       name  = "IMAGE_NAME"
       value = "backend"
     },
     {
        name  = "TARGET_DOCKERFILE"
        value = "docker/prod/Dockerfile"
     },
   ]
 }
}

output "production" {
 value = module.production

 sensitive = true
}
