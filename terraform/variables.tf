variable "project" {
  description = "Define an arbitrary project name in kebab-case (e.g.: cool-project-1436)"
  default     = "densfordcivil"
}

variable "project_name" {
  description = "Project name that follows naming convention for Reports"
  default     = "Densford Civil"
}

variable "profile" {
  description = "The aws-cli profile name to use for this operation"
  default     = "densfordcivil-access-key"
}

variable "region" {
  description = "The target region for the operations. If unset, defaults to \"ap-southeast-2\" (Sydney)"
  default     = "ap-southeast-2"
}

variable "zone" {
  description = "Relative to var.region, the target zone for the operations if asked for one. If unset, defaults to \"a\""
  default     = "a"
}

variable "primary_email_contact" {
  description = "This email will be used primarily for any notifications regarding the resources"
  default = "brian@horizondigital.au" 
  
}

variable "notify_email_addresses" {
  type        = list(string)
  description = "List of email addresses to send notifications to for any alerts. Does not include `var.primary_email_contact` by default"
  default = [ "brian@horizondigital.au", "reece@horizondigital.au" ]
}

variable "monthly_budget_usd" {
  description = "How much are you willing to spend in USD every month?"
  default     = "100"
}

variable "architecture" {
  default = "x86_64" # can also use arm64
}

variable "ubuntu_code_name" {
  default = "jammy"
}

variable "ami_id" {
  nullable    = true
  default     = null
  description = "Use a specific AMI ID to use on the EC2 Instances. Useful for pinning AMI IDs where if not set, the most recent Ubuntu AMI will be used. This subjects the AMI ID to drift due to newer version of the Ubuntu AMI being regularly released"
}

variable "digitalocean_token" {
  description = "A DigitalOcean token to be used when provisioning subdomains. (reference: https://docs.digitalocean.com/reference/api/create-personal-access-token/)"
  sensitive   = true
  default = ""
}

variable "digitalocean_domain" {
  description = "The domain to use to append to the subdomain (inferred from project). Note that this domain must exist on the DigitalOcean account tied to the token"
  default = "densfordcivil.bsdl.xyz"
}

variable "github_owner" {
  default = "BlueSky-Digital-Labs"
}
