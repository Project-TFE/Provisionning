variable "vm_names" {
  type = list(string)
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "network_interface_ids" {
  type = list(string)
}

variable "os_disk_names" {
  type = list(string)
}

variable "admin_username" {
  type = string
}

variable "ssh_public_keys" {
  type = list(string)
}

variable "custom_data" {
  type        = list(string)
  description = "List of custom data scripts for each VM"
  default     = []
}

