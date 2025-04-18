resource "azurerm_linux_virtual_machine" "vm" {
  count               = length(var.vm_names)
  name                = var.vm_names[count.index]
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size  # Using the specified VM size
  admin_username      = var.admin_username
  custom_data         = var.custom_data[count.index]
  
  network_interface_ids = [
    var.network_interface_ids[count.index]
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_keys[count.index]
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = var.os_disk_names[count.index]
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
