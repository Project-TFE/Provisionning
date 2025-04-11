output "vm_ids" {
  description = "The IDs of the VMs"
  value       = azurerm_linux_virtual_machine.vm[*].id
}

output "vm_names" {
  description = "The names of the VMs"
  value       = azurerm_linux_virtual_machine.vm[*].name
}
