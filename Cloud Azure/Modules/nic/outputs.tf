output "nic_id" {
  description = "ID de l'interface réseau créée"
  value       = azurerm_network_interface.nic.id
}