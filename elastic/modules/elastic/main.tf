locals {
  vm_names = [for i in range(var.nodes_count) :
    "${var.prefix}-${i}"
  ]

  vm_ips = [for i in range(var.nodes_count) :
    "${cidrhost(var.subnet_cidr, var.base_ip_offset + i)}/${split("/", var.subnet_cidr)[1]}"
  ]

  # nodes_overrides = {
  #   cpu     = 4
  #   mem_mb  = 4096
  #   disk_gb = 20
  # }

  default_tags = [var.role, "opentofu"]
}

module "nodes_creation" {
  source = "../base"
  count  = var.nodes_count

  vm_name = local.vm_names[count.index]
  cpu     = var.cpu
  mem_mb  = var.mem_mb

  ip_address = var.cloud_init_enabled ? local.vm_ips[count.index] : null
  username   = var.username
  password   = var.password
  tags       = local.default_tags
}
