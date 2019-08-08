provider "azurerm" {
  version = "=1.30.1"
}

resource "azurerm_resource_group" "hashitraining" {
  name     = "${var.workshop-prefix}-workshop"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.workshop-prefix}-vnet"
  location            = "${azurerm_resource_group.hashitraining.location}"
  address_space       = ["${var.address_space}"]
  resource_group_name = "${azurerm_resource_group.hashitraining.name}"
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.workshop-prefix}-subnet"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${azurerm_resource_group.hashitraining.name}"
  address_prefix       = "${var.subnet_prefix}"
}

resource "azurerm_network_security_group" "vault-sg" {
  name                = "${var.workshop-prefix}-sg"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.hashitraining.name}"

  security_rule {
    name                       = "Vault"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8200"
    source_address_prefix      = "${var.vault_source_ips}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Vault-ssl"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "${var.vault_source_ips}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Vault-public"
    priority                   = 111
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "${var.vault_source_ips}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Transit-App"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "${var.ssh_source_ips}"
    destination_address_prefix = "*"
  }
}
