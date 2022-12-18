
locals {
  connectivity_private = length(var.subnet_ids) > 0 ? true : false
  ip_address_type      = local.connectivity_private ? "Private" : "Public"
  dns_name_label       = local.connectivity_private ? null : var.dns_name_label
  subnet_ids           = local.connectivity_private ? null : var.subnet_ids
}

resource "azurerm_container_group" "container_group" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = var.os_type
  restart_policy      = var.restart_policy

  subnet_ids      = local.subnet_ids
  dns_name_label  = local.dns_name_label
  ip_address_type = local.ip_address_type

  dynamic "image_registry_credential" {
    for_each = var.image_registry_credentials

    content {
      username = image_registry_credential.value.username
      password = image_registry_credential.value.password
      server   = image_registry_credential.value.server
    }
  }

  dynamic "container" {
    for_each = var.containers

    content {
      name  = container.key
      image = container.value.image

      cpu          = container.value.cpu
      cpu_limit    = container.value.cpu_limit
      memory       = container.value.memory
      memory_limit = container.value.memory_limit

      environment_variables = container.value.env

      dynamic "ports" {
        for_each = container.value.ports

        content {
          port     = ports.key
          protocol = ports.value
        }
      }
    }
  }

  tags = var.tags
}