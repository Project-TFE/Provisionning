variable "public_ip_name" {
    type = string
    description = "Public IP for frontend in Azure"
    default = "front_public_ip"
}


variable "network_interface_name_1" {
    type = string
    description = "NIC name for front in Azure"
    default = "nic_front"
}

variable "network_interface_name_2" {
    type = string
    description = "NIC name for backend Azure"
    default = "nic_back"
}







