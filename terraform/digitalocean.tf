provider "digitalocean" {
  token = var.digitalocean_token
}

data "digitalocean_domain" "this" {
  name = var.digitalocean_domain
}
