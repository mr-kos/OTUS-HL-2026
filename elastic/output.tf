# output "info_server_test" {
#   value = {
#     name = proxmox_virtual_environment_vm.ipDeb.name
#     ip   = length(proxmox_virtual_environment_vm.ipDeb.ipv4_addresses) > 0 ? flatten(proxmox_virtual_environment_vm.ipDeb.ipv4_addresses) : null
#   }
# }
