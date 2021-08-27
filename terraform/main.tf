terraform {
  backend "azurerm" {
    resource_group_name  = "yqs-rg"
    storage_account_name = "yqstfstate26284"
    container_name       = "tfstate"
    key                  = "terraform-vault.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version         =   "~> 2.0"
    }
	azuread = {
      source  = "hashicorp/azuread"
      version         =   ">= 0.11"
    }
  }

}

# Provider Block

provider "azurerm" {
    
    features {}
}

provider "azuread" {
    
    alias           =   "ad"
}

######################### Resources #####################
#

#resource "azurerm_virtual_network" "main" {
#  name                = "${var.prefix}-pipeline-network"
#  address_space       = ["10.0.0.0/16"]
#  location            = azurerm_resource_group.main.location
#  resource_group_name = azurerm_resource_group.main.name
#}
#
#resource "azurerm_subnet" "internal" {
#  name                 = "internal"
#  resource_group_name  = azurerm_resource_group.main.name
#  virtual_network_name = azurerm_virtual_network.main.name
#  address_prefixes     = ["10.0.2.0/24"]
#}

resource "azurerm_public_ip" "main" {
  name                = "${var.prefix}-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name =  "${var.resource_group_name}"
  allocation_method   = "Dynamic"
  domain_name_label   = "${var.prefix}-is-testing"

  tags = {
    environment = "sandbox"
  }
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.main.id]
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
    Owner = "YQS"
    environment = "hashicorp-vault"
  }
}
