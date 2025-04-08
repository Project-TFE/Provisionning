output "vm_ids" {
  description = "The IDs of the virtual machines"
  value       = azurerm_linux_virtual_machine.linux_vm[*].id
}

output "vm_names" {
  description = "The names of the virtual machines"
  value       = azurerm_linux_virtual_machine.linux_vm[*].name
}
