variable "role" {
  description = "Role of the resource"
  type        = string
  default     = "elasticsearch"
}

variable "nodes_count" {
  description = "Nodes in elasticsearch cluster"
  type        = number
  default     = 3
}

variable "prefix" {
  description = "Machines name prefix"
  type        = string
  default     = "es"
}

variable "cpu" {
  description = "CPU cores count"
  type        = number
  default     = 2
}

variable "mem_mb" {
  description = "RAM in MB"
  type        = number
  default     = 4096
}

variable "disk_gb" {
  description = "Storage in GB"
  type        = number
  default     = 20
}

variable "subnet_cidr" {
  description = "Subnet CIDR for IP assignment"
  type        = string
  default     = "172.16.0.0/24"
}

variable "base_ip_offset" {
  description = "Starting IP offset"
  type        = number
  default     = 100
}

variable "additional_tags" {
  description = "Additional tags to merge with defaults"
  type        = map(string)
  default     = {}
}

variable "cloud_init_enabled" {
  description = "Enable cloud-init configuration"
  type        = bool
  default     = true
}

variable "username" {
  description = "Base user username"
  type        = string
  sensitive   = true
  default     = null
}

variable "password" {
  description = "Base user password"
  type        = string
  sensitive   = true
  default     = null
}

# variable "shards_count" {
#   description = "Shards of indeces"
#   type        = number
#   default     = 3
# }

# variable "replication_factor" {
#   description = "Replicas per shard"
#   type        = number
#   default     = 1
# }
