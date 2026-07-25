# HL-2026. Terraform practice (lesson 3)

## 1) Настройка окружения
* Вместо yandex cloud использовал "homelab" Proxmox VE 9.2.5.
* Вместо terraform я использовал opentofu последней версии 1.12.5 (https://github.com/opentofu/opentofu/releases/download/v1.12.5/tofu_1.12.5_linux_amd64.tar.gz). И провайдер bpg/proxmox для него.


* Проверка правильности установки OpenTofu и провайдера

```bash
tofu --version
```
```output
OpenTofu v1.12.5
on linux_amd64
+ provider registry.opentofu.org/bpg/proxmox v0.111.1
```

* Создание учетной записи для использования в OpenTofu
	- Создание пользователя в гипервизоре

	```bash
	pveum user add tofu-prov@pve
	```

- Создание роли с необходимыми правами

	```bash
	pveum role add TofuProv -priv "Datastore.Allocate Datastore.AllocateSpace Datastore.AllocateTemplate Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify SDN.Use VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.PowerMgmt User.Modify Pool.Audit"
	```

- Добавление соответствия роли пользователю через ACL

	```bash
	pveum aclmod / -user tofu-prov@pve -role TofuProv
	```

- Выпуск API токена для взаимодействия с PVE через tofu

	```bash
	pveum user token add tofu-prov@pve tofu-token -privsep=0
	```

- Создание одноименного пользователя на ноде (необходимо для выполнения некоторых команд, которые нельзя выполнить через токен [загрузка файла на диск, создание диска виртуальной машины]. В этом случае взаимодействие происходит через ssh).

	```bash
	useradd -m -G sudo tofu-prov
	passwd tofu-prov
	```

* Был загружен debian-13-cloud образ (https://cloud.debian.org/images/cloud/trixie/latest/debian-13-generic-amd64.qcow2)
* В cloud-образ был установлен пакет qemu-guest-agent, соответствующий сервис был добавлен в автозагрузку. Это необходимо для получения IP адреса с целевой машины (см. блок agent в main.tf)

```bash
virt-customize -a /var/lib/vz/template/iso/debian-13.img --install qemu-guest-agent
virt-customize -a /var/lib/vz/template/iso/debian-13.img --run-command 'systemctl enable qemu-guest-agent'
```

## 2) Настройка ресурсов, переменных, данных вывода для OpenTofu
* в PVE нам доступна одна нода
	- 64 ГБ ОЗУ
	- 500 ГБ хранилища
	- 16 логических ядер
* параметры для PVE описаны в pve_vars.tf
* параметры для виртуальных машин описаны в vm_vars.tf
* провайдер описан в providers.tf
* загрузка cloud-images осуществлялась через ресурс proxmox_download (описан в images.tf)
* секреты записаны в terraform.tfvars (в .gitignore)
* интересующие нас данные для вывода в output.tf

## 3) Запуск OpenTofu
```bash
tofu init
```

<details>  
	<summary>Output</summary>

	Initializing the backend...
	
	Initializing provider plugins...
	- Reusing previous version of bpg/proxmox from the dependency lock file
	- Using previously-installed bpg/proxmox v0.111.1
	
	OpenTofu has made some changes to the provider dependency selections recorded
	in the .terraform.lock.hcl file. Review those changes and commit them to your
	version control system if they represent changes you intended to make.
	
	OpenTofu has been successfully initialized!
	
	You may now begin working with OpenTofu. Try running "tofu plan" to see
	any changes that are required for your infrastructure. All OpenTofu commands
	should now work.
	
	If you ever set or change modules or backend configuration for OpenTofu,
	rerun this command to reinitialize your working directory. If you forget, other
	commands will detect it and remind you to do so if necessary.
	
</details>

```bash
tofu plan
```

<details>  
	<summary>Output</summary>

```
OpenTofu used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

OpenTofu will perform the following actions:

  # proxmox_virtual_environment_vm.ipDeb will be created
  + resource "proxmox_virtual_environment_vm" "ipDeb" {
      + acpi                                 = true
      + bios                                 = "seabios"
      + boot_order                           = (known after apply)
      + delete_unreferenced_disks_on_destroy = true
      + description                          = "HL-2026. 3. Managed by ToFu"
      + hotplug                              = (known after apply)
      + id                                   = (known after apply)
      + ipv4_addresses                       = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + keyboard_layout                      = "en-us"
      + mac_addresses                        = (known after apply)
      + migrate                              = false
      + name                                 = "ipDeb"
      + network_device                       = [
          + {
              + bridge      = "vmbr1"
              + enabled     = true
              + firewall    = false
              + mac_address = (known after apply)
              + model       = "virtio"
              + mtu         = 0
              + queues      = 0
              + rate_limit  = 0
              + vlan_id     = 0
            },
        ]
      + network_interface_names              = (known after apply)
      + node_name                            = "pve"
      + on_boot                              = true
      + protection                           = false
      + purge_on_destroy                     = true
      + reboot                               = false
      + reboot_after_update                  = true
      + scsi_hardware                        = "virtio-scsi-pci"
      + started                              = true
      + stop_on_destroy                      = false
      + tablet_device                        = true
      + template                             = false
      + timeout_clone                        = 1800
      + timeout_create                       = 1800
      + timeout_migrate                      = 1800
      + timeout_move_disk                    = 1800
      + timeout_reboot                       = 1800
      + timeout_shutdown_vm                  = 1800
      + timeout_start_vm                     = 1800
      + timeout_stop_vm                      = 300
      + vm_id                                = (known after apply)

      + agent {
          + enabled = true
          + timeout = "30s"
          + trim    = false
          + type    = "virtio"

          + wait_for_ip {
              + disabled = false
              + ipv4     = true
              + ipv6     = false
            }
        }

      + cpu {
          + cores      = 2
          + hotplugged = 0
          + limit      = 0
          + numa       = false
          + sockets    = 1
          + type       = "qemu64"
          + units      = (known after apply)
        }

      + disk {
          + aio               = "io_uring"
          + backup            = true
          + cache             = "none"
          + datastore_id      = "vm-storage"
          + discard           = "ignore"
          + file_format       = "raw"
          + file_id           = "local:iso/debian-13-agented.img"
          + interface         = "scsi0"
          + iothread          = false
          + path_in_datastore = (known after apply)
          + queues            = 0
          + replicate         = true
          + size              = 20
          + ssd               = false
        }

      + initialization {
          + datastore_id         = "vm-storage"
          + file_format          = (known after apply)
          + meta_data_file_id    = (known after apply)
          + network_data_file_id = (known after apply)
          + type                 = (known after apply)
          + upgrade              = (known after apply)
          + user_data_file_id    = (known after apply)
          + vendor_data_file_id  = (known after apply)

          + ip_config {
              + ipv4 {
                  + address = "dhcp"
                }
            }

          + user_account {
              + keys     = [
                  + <<-EOT
                        ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCfTNKYxyFK7P+909yT4wzFVB5duq4WHekGZ3BLZjDrnTua25OS1wnccx73DgDC7yG/it3fgDNxqQd0jluzSyI5rTZ20ov9bsoh0xhMmfZnP9cmRlOyxjuxfyf1uzOZfmUYnDVWdUon8wmVczlWJJb5JvQkFyMQqJNO77zVxkQAWgtYfhPfqhPzSk1IMLrN7z2fcpQMlbjQoM6DFMWxscToy1LbUpVRBRMuhcncW2GfYECUn/O4z/Va1YNsK7me9SQEQhmayjj0rvKDm5B343lH03ctBmzHSmaNCcC5btvkVDeyWoHtB/k6my2/3c7LRvhZl9DeZev17SWSe9lsVMBIDDpEXGwatYX/eB9yksENfybNtsA4rZJba12cIqgz7hNcnLP42gWyay8FCg0W7Hud6vbMJuPVGjXKB37nAMkionGuyT/jdEAHXH9bVmkKdRdK6ZHBvvkrv2tGaDWUEj+9R4znt47Y//XRMIB4N/PDdseC0mIiVPnamft9/nsG1OU= user@host
                    EOT,
                ]
              + password = (sensitive value)
              + username = (sensitive value)
            }
        }

      + memory {
          + dedicated      = 2048
          + floating       = 0
          + keep_hugepages = false
          + shared         = 0
        }

      + operating_system {
          + type = "l26"
        }

      + vga (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + info_server_test = {
      + ip   = (known after apply)
      + name = "ipDeb"
    }

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so OpenTofu can't guarantee to take exactly these actions if you run "tofu apply" now.
```

</details>

```bash
tofu apply
```

<details>  
	<summary>Output</summary>

```
OpenTofu used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

OpenTofu will perform the following actions:

  # proxmox_virtual_environment_vm.ipDeb will be created
  + resource "proxmox_virtual_environment_vm" "ipDeb" {
      + acpi                                 = true
      + bios                                 = "seabios"
      + boot_order                           = (known after apply)
      + delete_unreferenced_disks_on_destroy = true
      + description                          = "HL-2026. 3. Managed by ToFu"
      + hotplug                              = (known after apply)
      + id                                   = (known after apply)
      + ipv4_addresses                       = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + keyboard_layout                      = "en-us"
      + mac_addresses                        = (known after apply)
      + migrate                              = false
      + name                                 = "ipDeb"
      + network_device                       = [
          + {
              + bridge      = "vmbr1"
              + enabled     = true
              + firewall    = false
              + mac_address = (known after apply)
              + model       = "virtio"
              + mtu         = 0
              + queues      = 0
              + rate_limit  = 0
              + vlan_id     = 0
            },
        ]
      + network_interface_names              = (known after apply)
      + node_name                            = "pve"
      + on_boot                              = true
      + protection                           = false
      + purge_on_destroy                     = true
      + reboot                               = false
      + reboot_after_update                  = true
      + scsi_hardware                        = "virtio-scsi-pci"
      + started                              = true
      + stop_on_destroy                      = false
      + tablet_device                        = true
      + template                             = false
      + timeout_clone                        = 1800
      + timeout_create                       = 1800
      + timeout_migrate                      = 1800
      + timeout_move_disk                    = 1800
      + timeout_reboot                       = 1800
      + timeout_shutdown_vm                  = 1800
      + timeout_start_vm                     = 1800
      + timeout_stop_vm                      = 300
      + vm_id                                = (known after apply)

      + agent {
          + enabled = true
          + timeout = "30s"
          + trim    = false
          + type    = "virtio"

          + wait_for_ip {
              + disabled = false
              + ipv4     = true
              + ipv6     = false
            }
        }

      + cpu {
          + cores      = 2
          + hotplugged = 0
          + limit      = 0
          + numa       = false
          + sockets    = 1
          + type       = "qemu64"
          + units      = (known after apply)
        }

      + disk {
          + aio               = "io_uring"
          + backup            = true
          + cache             = "none"
          + datastore_id      = "vm-storage"
          + discard           = "ignore"
          + file_format       = "raw"
          + file_id           = "local:iso/debian-13-agented.img"
          + interface         = "scsi0"
          + iothread          = false
          + path_in_datastore = (known after apply)
          + queues            = 0
          + replicate         = true
          + size              = 20
          + ssd               = false
        }

      + initialization {
          + datastore_id         = "vm-storage"
          + file_format          = (known after apply)
          + meta_data_file_id    = (known after apply)
          + network_data_file_id = (known after apply)
          + type                 = (known after apply)
          + upgrade              = (known after apply)
          + user_data_file_id    = (known after apply)
          + vendor_data_file_id  = (known after apply)

          + ip_config {
              + ipv4 {
                  + address = "dhcp"
                }
            }

          + user_account {
              + keys     = [
                  + <<-EOT
                        ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCfTNKYxyFK7P+909yT4wzFVB5duq4WHekGZ3BLZjDrnTua25OS1wnccx73DgDC7yG/it3fgDNxqQd0jluzSyI5rTZ20ov9bsoh0xhMmfZnP9cmRlOyxjuxfyf1uzOZfmUYnDVWdUon8wmVczlWJJb5JvQkFyMQqJNO77zVxkQAWgtYfhPfqhPzSk1IMLrN7z2fcpQMlbjQoM6DFMWxscToy1LbUpVRBRMuhcncW2GfYECUn/O4z/Va1YNsK7me9SQEQhmayjj0rvKDm5B343lH03ctBmzHSmaNCcC5btvkVDeyWoHtB/k6my2/3c7LRvhZl9DeZev17SWSe9lsVMBIDDpEXGwatYX/eB9yksENfybNtsA4rZJba12cIqgz7hNcnLP42gWyay8FCg0W7Hud6vbMJuPVGjXKB37nAMkionGuyT/jdEAHXH9bVmkKdRdK6ZHBvvkrv2tGaDWUEj+9R4znt47Y//XRMIB4N/PDdseC0mIiVPnamft9/nsG1OU= user@host
                    EOT,
                ]
              + password = (sensitive value)
              + username = (sensitive value)
            }
        }

      + memory {
          + dedicated      = 2048
          + floating       = 0
          + keep_hugepages = false
          + shared         = 0
        }

      + operating_system {
          + type = "l26"
        }

      + vga (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + info_server_test = {
      + ip   = (known after apply)
      + name = "ipDeb"
    }

Do you want to perform these actions?
  OpenTofu will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

proxmox_virtual_environment_vm.ipDeb: Creating...
proxmox_virtual_environment_vm.ipDeb: Still creating... [10s elapsed]
proxmox_virtual_environment_vm.ipDeb: Creation complete after 19s [id=100]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

info_server_test = {
  "ip" = [
    "127.0.0.1",
    "192.168.0.68",
  ]
  "name" = "ipDeb"
}
```

</details>

## 4) Проверка доступности
Как видно из вывода последней команды, DHCP-сервер выдал свежеразвернутой машине адрес 192.168.0.68. Попробуем подключиться к нему по SSH, используя ранее заданные на стадии инициализации (cloud-init) логин и ключ.

```bash
ssh -i ~/.ssh/pve_rsa user@192.168.0.68
```

```
The authenticity of host '192.168.0.68 (192.168.0.68)' can't be established.
ED25519 key fingerprint is SHA256:rv4Xut5Q8/T/WKvhIhCMvpBdl7EZ1iy4xVbggze5vws.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.0.68' (ED25519) to the list of known hosts.
Linux ipDeb 6.12.95+deb13-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.12.95-1 (2026-07-04) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
user@ipDeb:~$
```

## 5) Что нужно, чтобы повторить
* Иметь доступ к Proxmox VE >= 9.x
* Настроить VE пользователя и пользователя непосредственно ноды (Linux PAM), в соответствии с п.1
* Сгенерировать свой ssh-ключ для пользователя VM и поменять в параметрах инициализации путь до него
* Кастомизировать любой cloud-образ, установив туда qemu gues agent и добавив в автозагрузку (далее использовать именно этот образ, см. п.1)
* terraform/tofu init > plan > apply
