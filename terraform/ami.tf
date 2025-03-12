# Fallback AMI if you don't specify var.ami_id
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-${var.ubuntu_code_name}-*"]
  }

  filter {
    name   = "architecture"
    values = [var.architecture]
  }

  owners = [local.ami_owner_canonical] # Canonical
}