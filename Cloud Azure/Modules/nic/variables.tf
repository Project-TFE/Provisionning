variable "nic_name" {
  description = "Nom de l'interface réseau"
  type        = string
}

variable "location" {
  description = "Emplacement Azure"
  type        = string
}

variable "resource_group_name" {
  description = "Nom du Resource Group"
  type        = string
}

variable "subnet_id" {
  description = "ID du sous-réseau auquel connecter la NIC"
  type        = string
}

variable "public_ip_address_id" {
  description = "ID de l'IP publique à associer à la NIC (optionnel)"
  type        = string
  default     = null
}