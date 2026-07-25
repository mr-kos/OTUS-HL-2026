# resource "proxmox_download_file" "debian13_cloud_image" {
#   content_type = "iso"
#   datastore_id = "local"
#   node_name    = var.proxmox_node
#   # url          = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-generic-amd64.qcow2"
#   overwrite    = false # This stops the provider from checking for upstream changes
#   file_name    = "debian-13.img"
# }

# resource "proxmox_download_file" "ubuntu24_cloud_image" {
#   content_type = "iso"
#   datastore_id = "local"
#   node_name    = var.proxmox_node
#   url          = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
#   overwrite    = false # This stops the provider from checking for upstream changes
#   file_name    = "ubuntu-server-24.img"
# }
