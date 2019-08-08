output "resource_group" {
  value = "${azurerm_resource_group.hashitraining.name}"
}

output "resource_group_location" {
  value = "${azurerm_resource_group.hashitraining.location}"
}

output "network" {
  value = "${azurerm_virtual_network.vnet.id}"
}

output "subnet" {
  value = "${azurerm_subnet.subnet.id}"
}

output "vault_sg" {
  value = "${azurerm_network_security_group.vault-sg.id}"
}
