resource "azurerm_linux_virtual_machine" "linux_vm" {
  count               = length(var.vm_names)
  name                = var.vm_names[count.index]
  resource_group_name = var.resource_group_name
  location            = var.location
  network_interface_ids = [var.network_interface_ids[count.index]]
  size                = var.vm_size

  os_disk {
    name                  = var.os_disk_names[count.index]
    caching               = "ReadWrite"
    storage_account_type  = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name          = var.vm_names[count.index]
  admin_username         = var.admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_keys[count.index]
  }
}
