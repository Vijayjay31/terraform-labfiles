terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.44.1"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "Az-lap-rg" {
  name     = "azlaprg80"
  location = "East US"

}

resource "azurerm_virtual_network" "az-lab-vnet" {
  name                = "azlabven80"
  resource_group_name = azurerm_resource_group.Az-lap-rg.name
  location            = azurerm_resource_group.Az-lap-rg.location
  address_space       = ["10.0.0.0/16"]

}

resource "azurerm_subnet" "az-lab-subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.Az-lap-rg.name
  virtual_network_name = azurerm_virtual_network.az-lab-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "az-lap-SG" {
  name                = "azlapsecuritygroup"
  resource_group_name = azurerm_resource_group.Az-lap-rg.name
  location            = azurerm_resource_group.Az-lap-rg.location

  security_rule {
    name                       = "Az-slap-ng-rule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_network_interface" "az-lap-net-interface" {
  name                = "az-lap-net-interface"
  resource_group_name = azurerm_resource_group.Az-lap-rg.name
  location            = azurerm_resource_group.Az-lap-rg.location

  ip_configuration {
    name                          = "intenal"
    subnet_id                     = azurerm_subnet.az-lab-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

}

resource "azurerm_network_interface_security_group_association" "az-lab-net-nsg" {
  network_interface_id      = azurerm_network_interface.az-lap-net-interface.id
  network_security_group_id = azurerm_network_security_group.az-lap-SG.id

}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.az-lab-subnet.id
  network_security_group_id = azurerm_network_security_group.az-lap-SG.id
}
