terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.111.1"
    }
  }
}

provider "proxmox" {
  alias     = "default"
  endpoint  = var.proxmox_endpoint
  username  = var.proxmox_username
  password  = var.proxmox_password
  api_token = var.proxmox_token
  insecure  = true # false if ssl certificate is valid (not self-signed or is in ca-trust list)
  ssh {
    agent    = false
    username = var.proxmox_ssh_username
    password = var.proxmox_ssh_password
    node {
      name    = var.proxmox_node
      address = var.proxmox_ssh_host
      port    = var.proxmox_ssh_port
    }
  }
}
