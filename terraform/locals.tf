locals {
  default_availability_zone = "${var.region}${var.zone}"

  any_ipv4_address = "0.0.0.0/0"

  ami_owner_canonical = "099720109477"

  terraform_github_template_name = "terraform-github-template"
}