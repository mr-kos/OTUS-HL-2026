output "vm_info" {
  value = {
    id   = proxmox_virtual_environment_vm.vm.vm_id
    name = proxmox_virtual_environment_vm.vm.name
    ip   = length(proxmox_virtual_environment_vm.vm.ipv4_addresses) > 0 ? flatten(proxmox_virtual_environment_vm.vm.ipv4_addresses) : null
  }
}
