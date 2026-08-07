module "elasticsearch_cluster" {
  source = "./modules/elastic"
  providers = {
    proxmox = proxmox.default
  }
  username = var.vm_admin_username
  password = var.vm_admin_password
}
