variable "vm_name" {
  type    = string
  default = "vm"
}

variable "vm_cpu" {
  description = "CPU cores"
  type        = number
  default     = 2
}

variable "vm_mem" {
  description = "RAM in MB"
  type        = number
  default     = 2048
}

variable "vm_admin_username" {
  description = "Default username for VM admin"
  type        = string
  sensitive   = true
}

variable "vm_admin_password" {
  description = "Default password for default VM admin"
  type        = string
  sensitive   = true
}
