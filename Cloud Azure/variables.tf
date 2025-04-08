variable "public_ip_name" {
    type = string
    description = "Public IP for Jenkins and Sonarqube in Azure"
    default = "public_ip_jenk"
}


variable "network_interface_name_1" {
    type = string
    description = "NIC name for jenkins in Azure"
    default = "nic_jenk"
}

variable "network_interface_name_2" {
    type = string
    description = "NIC name for sonarqube Azure"
    default = "nic_sonar"
}







