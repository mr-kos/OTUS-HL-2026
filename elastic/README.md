# HL-2026. ElasticSearch (lesson 14)

## 1) Окружение
* Вместо yandex cloud использовал "homelab" Proxmox VE 9.2.5.
* Вместо terraform я использовал opentofu последней версии 1.12.5 (https://github.com/opentofu/opentofu/releases/download/v1.12.5/tofu_1.12.5_linux_amd64.tar.gz). И провайдер bpg/proxmox для него.
* Для PVE была создана отдельная роль, отдельный пользователь, для которого выпущен API token. Также на хосте был создан пользователь, соответствующий пользователю в PVE (зачем это было сделано можно увидеть в ../terraform/README.md, как и сам процесс настройки PVE и хоста)
* Базовый образ: debian-13-cloud (https://cloud.debian.org/images/cloud/trixie/latest/debian-13-generic-amd64.qcow2) с предустановленным qemu-агентом.

## 2) Настройка ресурсов, переменных, данных вывода для OpenTofu
* elasticsearch cluster будет состоять из 3-х нод, каждая из которых будет иметь следующие характеристики:
  - 1 CPU
  - 4 GB RAM
  - 10 GB disk space
* 2 web-сервера (nginx) "black" и "white", каждый:
  - 1 CPU
  - 2 ГБ ОЗУ
  - 10 ГБ disk space
* 1 балансировщик (haproxy) "ha":
  - 2 CPU
  - 2 GB RAM
  - 10 GB disk space
* 1 база данных (postgres) "pg":
  - 2 CPU
  - 2 GB RAM
  - 10 GB disk space
* параметры для elasticsearch описаны в elastic_vars.tf
* параметры для web-серверов описаны в web_vars.tf
* параметры для балансировщиков описаны в balancer_vars.tf
* параметры для базы данных описаны в db_vars.tf
* параметры для PVE описаны в pve_vars.tf
* параметры для виртуальных машин описаны в vm_vars.tf
* провайдер описан в providers.tf

coming soon...
