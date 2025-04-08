resource "azurerm_resource_group" "rg" {
  name = "Ehealth-rg"
  location = "West Europe"
}

resource "azurerm_public_ip" "public_ip" {
    name = var.public_ip_name
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    allocation_method = "Dynamic"
}

resource "tls_private_key" "ssh_1" {
    algorithm = "RSA"
    rsa_bits = 4096
}
resource "tls_private_key" "ssh_2" {
    algorithm = "RSA"
    rsa_bits = 4096
}
module "network" {
  source              = "./Modules/vnet"
  vnet_name           = "Ehealth_Vnet"
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24"]
  subnet_names        = ["FrontNet", "BackNet"]

  depends_on = [ azurerm_resource_group.rg ]
}

module "nsg" {
  source              = "./Modules/nsg"
  nsg_name            = "Ehealth_NSG"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

module "nic_front" {
  source              = "./Modules/nic"
  nic_name            = "nic-front"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.network.subnet_ids["FrontNet"]
  public_ip_address_id = azurerm_public_ip.public_ip.id
}

module "nic_back" {
  source              = "./Modules/nic"
  nic_name            = "nic-back"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.network.subnet_ids["BackNet"]
}


module "vms" {
  source                = "./Modules/vms"
  vm_names             = ["EhealthFront", "EhealthBack"]
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  # network_interface_ids = [module.nic.nic_id, module.nic.nic_id]
  network_interface_ids = [module.nic_front.nic_id, module.nic_back.nic_id]
  os_disk_names        = ["os_disk_vm1", "os_disk_vm2"]
  admin_username       = "azureuser"
  ssh_public_keys      = [tls_private_key.ssh_1.public_key_openssh, tls_private_key.ssh_2.public_key_openssh]
}

