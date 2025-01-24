resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${module.lab.full_name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  default_node_pool {
    name                 = "default"
    node_count           = 1
    max_count            = 3
    min_count            = 1
    vm_size              = var.instance_size
    auto_scaling_enabled = true
  }

  dns_prefix = "aks-${module.lab.full_name}"

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
  }

  tags = module.lab.tags
}
