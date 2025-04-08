variable "vm_names" {
  description = "List of virtual machine names"
  type        = list(string)
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the VMs"
  type        = string
}

variable "network_interface_ids" {
  description = "List of network interface IDs"
  type        = list(string)
}

variable "vm_size" {
  description = "Size of the virtual machines"
  type        = string
  default     = "Standard_DS1_v2"
}

variable "os_disk_names" {
  description = "Names of the OS disks"
  type        = list(string)
}

variable "admin_username" {
  description = "Admin username for the virtual machines"
  type        = string
}

variable "ssh_public_keys" {
  description = "List of public SSH keys"
  type        = list(string)
}

