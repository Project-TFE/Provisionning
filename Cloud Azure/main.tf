resource "azurerm_resource_group" "rg" {
  name = "EhealthTFE-rg"
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
  subnet_prefixes     = ["10.0.4.0/24", "10.0.5.0/24"]
  subnet_names        = ["Jenkins", "Sonarqube"]

  depends_on = [ azurerm_resource_group.rg ]
}

module "nsg" {
  source              = "./Modules/nsg"
  nsg_name            = "Ehealth_NSG"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

module "nic_jenk" {
  source              = "./Modules/nic"
  nic_name            = "nic-jenk"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.network.subnet_ids["Jenkins"]
  public_ip_address_id = azurerm_public_ip.public_ip.id
}

module "nic_sonar" {
  source              = "./Modules/nic"
  nic_name            = "nic-sonar"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.network.subnet_ids["Sonarqube"]
  public_ip_address_id = azurerm_public_ip.public_ip.id
}


module "vms" {
  source                = "./Modules/vms"
  vm_names             = ["EhealthJenk", "EhealthSonar"]
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  network_interface_ids = [module.nic_jenk.nic_id, module.nic_soanr.nic_id]
  os_disk_names        = ["os_disk_vm1", "os_disk_vm2"]
  admin_username       = "azureuser"
  ssh_public_keys      = [tls_private_key.ssh_1.public_key_openssh, tls_private_key.ssh_2.public_key_openssh]
}

