output "ecr" {
  value = {
    backend  = module.backend_registry.repository_url
    frontend = module.frontend_registry.repository_url
  }
}

output "primary-private-key" {
  value     = tls_private_key.primary-key-pair.private_key_openssh
  sensitive = true
}

output "primary-public-key" {
  value = tls_private_key.primary-key-pair.public_key_openssh
}

output "ubuntu_recent_ami_id" {
  value = data.aws_ami.ubuntu.id
}

output "region" {
  value = var.region
}