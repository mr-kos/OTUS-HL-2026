variable "node_name" {
  description = "Proxmox VE host"
  type        = string
  default     = "pve"
}

variable "vm_name" {
  type    = string
  default = "vm"
}

variable "tags" {
  description = "Tags for the VM"
  type        = list(string)
  default     = []
}

variable "cpu" {
  description = "CPU cores"
  type        = number
  default     = 2
}

variable "mem_mb" {
  description = "RAM in MB"
  type        = number
  default     = 1024
}

variable "disk_opt" {
  description = "Storage base options"
  type = object({
    interface    = string
    datastore_id = string
    size         = number
    file_format  = string
    file_id      = string
  })
  default = {
    interface    = "scsi0"
    datastore_id = "vm-storage"
    size         = 10
    file_format  = "raw"
    file_id      = "local:iso/debian-13-agented.img"
  }
}

variable "network_device" {
  description = "Network device base configuration"
  type = object({
    bridge  = string
    model   = string
    vlan_id = number
  })
  default = {
    bridge  = "vmbr0"
    model   = "virtio"
    vlan_id = 100
  }
}

variable "ip_address" {
  description = "IP address (cidr)"
  type        = string
  default     = "dhcp"
}

variable "gateway" {
  description = "Network gateway"
  type        = string
  default     = null
}

variable "nameservers" {
  description = "Network nameservers list"
  type        = list(string)
  default     = null
}

variable "search_domain" {
  description = "Network search domain"
  type        = string
  default     = ""
}

variable "os_type" {
  description = "Type of OS"
  type        = string
  default     = "l26"
}

variable "username" {
  description = "Base user username"
  type        = string
  sensitive   = true
}

variable "password" {
  description = "Base user password"
  type        = string
  sensitive   = true
}
