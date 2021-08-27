
#
resource "azurerm_resource_group" "vault" {
  name     = "yqs-tf-demo-secure"
  location = "francecentral"
}

resource "azurerm_virtual_network" "vault" {
  name                = "${var.prefix}-vault-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.vault.location
  resource_group_name = azurerm_resource_group.vault.name
}

resource "azurerm_subnet" "vault" {
  name                 = "vault-subnet1"
  resource_group_name  = azurerm_resource_group.vault.name
  virtual_network_name = azurerm_virtual_network.vault.name
  address_prefixes       = ["${var.vault_subnet_address_prefix}"]
  network_security_group_id = azurerm_network_security_group.vault.id
}

resource "azurerm_public_ip" "vault" {
  name                = "${var.prefix}-pip"
  location            = azurerm_resource_group.vault.location
  resource_group_name = azurerm_resource_group.vault.name
  allocation_method   = "Dynamic"
  domain_name_label   = "${var.prefix}-is-testing"

  tags = {
    environment = "test"
	project = "somfy"
	Owner = "YQS"
  }
}

resource "azurerm_network_interface" "vault" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.vault.location
  resource_group_name = azurerm_resource_group.vault.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vault.id
  }
}

resource "azurerm_virtual_machine" "vault" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.vault.location
  resource_group_name   = azurerm_resource_group.vault.name
  network_interface_ids = [azurerm_network_interface.vault.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.prefix}-vm"
    admin_username = "testadmin"
    custom_data    = file("setup_vault.sh")
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("id_rsa.pub")
      path = "/home/testadmin/.ssh/authorized_keys"
    }  
  }
  tags = {
     environment = "test"
	project = "somfy"
	Owner = "YQS"
  }
}
####
resource "azurerm_network_security_group" "vault" {
  name                = "vault-nsg"
  location            = azurerm_resource_group.vault.location
  resource_group_name = azurerm_resource_group.vault.name
}

resource "azurerm_subnet_network_security_group_association" "vault" {
  subnet_id                 = azurerm_subnet.vault.id
  network_security_group_id = azurerm_network_security_group.vault.id
}

resource "azurerm_network_security_rule" "vault_allow_ssh" {
  name                        = "SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "var.allowed_source_address_prefixes"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.vault.name
  network_security_group_name = azurerm_network_security_group.vault.name
}
resource "azurerm_network_security_rule" "vault_allow_ui" {
  name                        = "8080"
  priority                    = 1010
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "var.allowed_source_address_prefixes"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.vault.name
  network_security_group_name = azurerm_network_security_group.vault.name
}

resource "azurerm_private_dns_zone" "main" {
  name                = var.private_dns_zone
  resource_group_name = azurerm_resource_group.vault.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vault" {
  name                  = "vault"
  resource_group_name   = azurerm_resource_group.vault.name
  private_dns_zone_name = azurerm_private_dns_zone.main.name
  virtual_network_id    = azurerm_virtual_network.vault.id
}