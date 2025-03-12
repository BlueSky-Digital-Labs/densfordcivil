module "backend_registry" {
  source = "./modules/registry"

  name = "backend" // Automatically prefixed with var.profile

  force_delete = true

  project = var.project
}

module "frontend_registry" {
  source = "./modules/registry"

  name = "frontend" // Automatically prefixed with var.profile

  force_delete = true

  project = var.project
}
