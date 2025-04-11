resource "azurerm_resource_group" "rg" {
  name = "EhealthTFE-rg"
  location = "West Europe"
}

resource "tls_private_key" "ssh_1" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "tls_private_key" "ssh_2" {
    algorithm = "RSA"
    rsa_bits = 4096
}

# Public IP for Jenkins
resource "azurerm_public_ip" "public_ip_jenkins" {
    name                = "public_ip_jenk"
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    allocation_method   = "Dynamic"
}

# Public IP for Sonarqube
resource "azurerm_public_ip" "public_ip_sonar" {
    name                = "public_ip_sonar"
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    allocation_method   = "Dynamic"
}

# Public IP for Control
resource "azurerm_public_ip" "public_ip_control" {
    name                = "public_ip_control"
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    allocation_method   = "Dynamic"
}

# Add Control subnet
module "network" {
  source              = "./Modules/vnet"
  vnet_name           = "Ehealth_Vnet"
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  subnet_names        = ["Jenkins", "Sonarqube", "Control"]

  depends_on = [ azurerm_resource_group.rg ]
}

# NIC for Control
module "nic_control" {
  source              = "./Modules/nic"
  nic_name            = "nic-control"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.network.subnet_ids["Control"]
  public_ip_address_id = azurerm_public_ip.public_ip_control.id
}

# Add SSH key for Control
resource "tls_private_key" "ssh_3" {
    algorithm = "RSA"
    rsa_bits = 4096
}

# Update VMs module
module "vms" {
  source                = "./Modules/vms"
  vm_names             = ["EhealthJenk", "EhealthSonar", "EhealthControl"]
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  network_interface_ids = [module.nic_jenk.nic_id, module.nic_sonar.nic_id, module.nic_control.nic_id]
  os_disk_names        = ["os_disk_vm1", "os_disk_vm2", "os_disk_vm3"]
  admin_username       = "azureuser"
  ssh_public_keys      = [tls_private_key.ssh_1.public_key_openssh, tls_private_key.ssh_2.public_key_openssh, tls_private_key.ssh_3.public_key_openssh]
  custom_data          = [
    base64encode(file("${path.module}/cloud-init-minimal.yml")),
    base64encode(file("${path.module}/cloud-init-minimal.yml")),
    base64encode(file("${path.module}/cloud-init-control.yml"))
  ]
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
  public_ip_address_id = azurerm_public_ip.public_ip_jenkins.id
}

module "nic_sonar" {
  source              = "./Modules/nic"
  nic_name            = "nic-sonar"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.network.subnet_ids["Sonarqube"]
  public_ip_address_id = azurerm_public_ip.public_ip_sonar.id
}


# module "vms" {
#   source                = "./Modules/vms"
#   vm_names             = ["EhealthJenk", "EhealthSonar"]
#   resource_group_name  = azurerm_resource_group.rg.name
#   location             = azurerm_resource_group.rg.location
#   network_interface_ids = [module.nic_jenk.nic_id, module.nic_sonar.nic_id]
#   os_disk_names        = ["os_disk_vm1", "os_disk_vm2"]
#   admin_username       = "azureuser"
#   ssh_public_keys      = [tls_private_key.ssh_1.public_key_openssh, tls_private_key.ssh_2.public_key_openssh]
#   custom_data          = [base64encode(file("${path.module}/cloud-init-jenkins.yml")), base64encode(file("${path.module}/cloud-init-sonar.yml"))]
# }


# Output the private keys to .pem files
resource "local_file" "private_key_jenkins" {
    content  = tls_private_key.ssh_1.private_key_pem
    filename = "${path.module}/jenkins.pem"
    file_permission = "0600"
}

resource "local_file" "private_key_sonar" {
    content  = tls_private_key.ssh_2.private_key_pem
    filename = "${path.module}/sonar.pem"
    file_permission = "0600"
}

resource "local_file" "private_key_control" {
    content  = tls_private_key.ssh_3.private_key_pem
    filename = "${path.module}/control.pem"
    file_permission = "0600"
}

