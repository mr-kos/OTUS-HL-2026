locals {
  nodes = {
    for i in range(var.nodes_count) : "${var.prefix}-${i}" => {
      ip = "${cidrhost(var.subnet_cidr, var.base_ip_offset + i)}/${split("/", var.subnet_cidr)[1]}"
      user = var.username
      password = var.password
      default_tags = [var.role, "opentofu"]
    }
  }
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/ansible/inventory.yaml"

  content = templatefile("${path.module}/inventory.tpl", {
    cluster_nodes = local.nodes
  })
}

module "nodes_creation" {
  source = "../base"
  for_each  = local.nodes

  vm_name = each.key
  cpu     = var.cpu
  mem_mb  = var.mem_mb

  ip_address = var.cloud_init_enabled ? each.value.ip : null
  username   = each.value.user
  password   = each.value.password
  tags       = each.value.default_tags
}
