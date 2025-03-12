terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    profile = "d32-access-key"
    region = "ap-southeast-2"
    bucket = "district32-terraform-states"
    key    = "terraform.tfstate"
  }
}

provider "aws" {
  profile = var.profile
  region  = var.region

  default_tags {
    tags = {
      ClientName = var.project_name 
      Project   = var.project_name
      Terraform = "YES"
      CreatedBy = "Reece"
    }
  }
}

module "budget" {
  # Currently `0` due to the Horizon Digital AWS Organization being under a parent organisational unit (you can't make budgets with tags work!)
  count  = 0
  source = "./modules/budget"

  monthly_budget_usd = var.monthly_budget_usd

  notify_email_addresses = var.notify_email_addresses

  project = var.project
}
