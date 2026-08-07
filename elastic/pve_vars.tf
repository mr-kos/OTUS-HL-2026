variable "proxmox_endpoint" {
  description = "Proxmox VE API URL"
  type        = string
  sensitive   = true
}

variable "proxmox_token" {
  description = "Proxmox VE API token"
  type        = string
  sensitive   = true
}

variable "proxmox_ssh_username" {
  type      = string
  sensitive = true
}

variable "proxmox_ssh_password" {
  type      = string
  sensitive = true
}

variable "proxmox_ssh_host" {
  type      = string
  sensitive = true
}

variable "proxmox_ssh_port" {
  type      = number
  sensitive = true
}

variable "proxmox_ssh_privkey" {
  type      = string
  sensitive = true
}

variable "proxmox_username" {
  type      = string
  sensitive = true
}

variable "proxmox_password" {
  type      = string
  sensitive = true
}

variable "proxmox_node" {
  description = "Proxmox VE host"
  type        = string
  default     = "pve"
}

# variable "proxmox_datastore_id" {
#   description = "Proxmox VE datastore to use"
#   type        = string
#   default     = "vm-storage"
# }
