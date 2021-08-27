resource "azurerm_virtual_network_peering" "jenkins_to_vault" {
  name                      = "jenkins_to_vault"
  resource_group_name       = azurerm_resource_group.jenkins.name
  virtual_network_name      = azurerm_virtual_network.jenkins.name
  remote_virtual_network_id = azurerm_virtual_network.vault.id
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "vault_to_jenkins" {
  name                      = "vault_to_jenkins"
  resource_group_name       = azurerm_resource_group.vault.name
  virtual_network_name      = azurerm_virtual_network.vault.name
  remote_virtual_network_id = azurerm_virtual_network.jenkins.id
  allow_virtual_network_access = true
}


