
resource "azurerm_resource_group" "demo" {
  location = "westeurope"
  name     = "rg-container-group-demo-private-westeu"
}

resource "azurerm_virtual_network" "demo" {
  name                = "vnet-container-group-demo-001"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  address_space       = ["10.0.0.0/19"]
}

resource "azurerm_subnet" "container_group" {
  name                 = "snet-container-group-001"
  resource_group_name  = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.demo.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

module "container_group" {
  source = "../../"

  name                = "demo"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  subnet_ids          = [azurerm_subnet.container_group.id]

  containers = {
    hello-world = {
      image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
      cpu    = "0.5"
      memory = "0.5"
      ports = {
        "80" = "TCP"
      }
    }
  }
}