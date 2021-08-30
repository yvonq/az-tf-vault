


resource "azurerm_subnet" "jenkins" {
  name                 = "jenkins-subnet1"
  resource_group_name  = azurerm_resource_group.yqs-tf-demo-rg.name
  virtual_network_name = azurerm_virtual_network.yqs-tf-demo-network.name
  address_prefixes       = ["${var.jenkins_subnet_address_prefix}"]
 
}

resource "azurerm_public_ip" "jenkins" {
  name                = "${var.prefix}-jenkins-pip"
  location             = azurerm_resource_group.yqs-tf-demo-rg.location
  resource_group_name  = azurerm_resource_group.yqs-tf-demo-rg.name
  allocation_method   = "Dynamic"
  domain_name_label   = "${var.prefix}-jenkins-is-testing"

  tags = {
    environment = "test"
	project = "somfy"
	Owner = "YQS"
  }
}

resource "azurerm_network_interface" "jenkins" {
  name                = "${var.prefix}-jenkins-nic"
  location             = azurerm_resource_group.yqs-tf-demo-rg.location
  resource_group_name  = azurerm_resource_group.yqs-tf-demo-rg.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.jenkins.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jenkins.id
  }
}

resource "azurerm_virtual_machine" "jenkins" {
  name                  = "${var.prefix}-jenkins-vm"
  location             = azurerm_resource_group.yqs-tf-demo-rg.location
  resource_group_name  = azurerm_resource_group.yqs-tf-demo-rg.name
  network_interface_ids = [azurerm_network_interface.jenkins.id]
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
    computer_name  = "${var.prefix}-jenkins-vm"
    admin_username = "testadmin"
    custom_data    = file("setup_jenkins.sh")
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
	project = "yqs-tf-demo-rg"
	Owner = "YQS"
  }
}
####
resource "azurerm_network_security_group" "jenkins" {
  name                = "jenkins-nsg"
  location             = azurerm_resource_group.yqs-tf-demo-rg.location
  resource_group_name  = azurerm_resource_group.yqs-tf-demo-rg.name
}

resource "azurerm_subnet_network_security_group_association" "jenkins" {
  subnet_id                 = azurerm_subnet.jenkins.id
  network_security_group_id = azurerm_network_security_group.jenkins.id
}

resource "azurerm_network_security_rule" "jenkins_allow_ssh" {
  name                        = "SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "var.allowed_source_address_prefixes"
  destination_address_prefix  = "*"
  resource_group_name  = azurerm_resource_group.yqs-tf-demo-rg.name
  network_security_group_name = azurerm_network_security_group.jenkins.name
}
resource "azurerm_network_security_rule" "jenkins_allow_ui" {
  name                        = "8080"
  priority                    = 1010
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "var.allowed_source_address_prefixes"
  destination_address_prefix  = "*"
  resource_group_name  = azurerm_resource_group.yqs-tf-demo-rg.name
  network_security_group_name = azurerm_network_security_group.jenkins.name
}


#resource "azurerm_private_dns_zone_virtual_network_link" "jenkins" {
#  name                  = "jenkins"
#  resource_group_name  = azurerm_resource_group.yqs-tf-demo-rg.name
#  private_dns_zone_name = azurerm_private_dns_zone.yqs-tf-demo-network.name
#  virtual_network_id    = azurerm_virtual_network.yqs-tf-demo-network.id
#}