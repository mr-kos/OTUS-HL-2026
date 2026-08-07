resource "proxmox_virtual_environment_vm" "vm" {
  name      = var.vm_name
  node_name = var.node_name

  description = "HL-2026"

  agent {
    enabled = true
    timeout = "30s"
    wait_for_ip {
      ipv4     = true
      disabled = false
    }
  }

  operating_system {
    type = var.os_type
  }

  cpu {
    cores = var.cpu
  }

  memory {
    dedicated = var.mem_mb
  }

  disk {
    interface    = var.disk_opt.interface
    datastore_id = var.disk_opt.datastore_id
    size         = var.disk_opt.size
    file_format  = var.disk_opt.file_format
    file_id      = var.disk_opt.file_id
  }

  network_device {
    bridge  = var.network_device.bridge
    model   = var.network_device.model
    vlan_id = var.network_device.vlan_id
  }

  initialization {
    datastore_id = var.disk_opt.datastore_id
    user_account {
      username = var.username
      password = var.password
      keys     = [file("${path.module}/.ssh/pve_rsa.pub")]
    }
    dns {
      domain  = var.search_domain
      servers = var.nameservers != null ? var.nameservers : ["${split("/", var.ip_address)[0]}"]
    }
    ip_config {
      ipv4 {
        address = var.ip_address
        gateway = var.gateway
      }
    }
  }

  tags = [for value in var.tags : value]

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      initialization[0]
    ]
  }
}
