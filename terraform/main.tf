resource "proxmox_virtual_environment_vm" "ipDeb" {
  name      = "ipDeb"
  node_name = var.proxmox_node

  description = "HL-2026. 3. Managed by ToFu"

  agent {
    enabled = true
    timeout = "30s"
    wait_for_ip {
      ipv4     = true
      disabled = false
    }
  }

  operating_system {
    type = "l26"
  }

  cpu {
    cores = var.vm_cpu
  }

  memory {
    dedicated = var.vm_mem
  }

  disk {
    interface    = "scsi0"
    datastore_id = var.proxmox_datastore_id
    size         = 20
    file_format  = "raw"
    file_id      = "local:iso/debian-13-agented.img"
  }

  network_device {
    bridge = "vmbr1"
    model  = "virtio"
  }

  initialization {
    datastore_id = var.proxmox_datastore_id
    user_account {
      username = var.vm_admin_username
      password = var.vm_admin_password
      keys     = [file("${path.module}/.ssh/pve_rsa.pub")]
    }
    ip_config {
      ipv4 {
        address = "dhcp"
      }

    }
  }
}
