
resource "azurerm_resource_group" "demo" {
  location = "westeurope"
  name     = "rg-container-group-demo-public-westeu"
}

module "container_group" {
  source = "../../"

  name                = "demo"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  dns_name_label      = "tomstech"

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