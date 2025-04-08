variable "nsg_name" {
  description = "The name of the network security group"
  type        = string
}

variable "resource_group_name" {
  description = "The resource group name"
  type        = string
}

variable "location" {
  description = "The location of the NSG"
  type        = string
}
