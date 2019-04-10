variable "rg_name" {
    default = "KubeTest"
}

variable "location" {
    default = "eastus"
}

variable "vnet_address_space" {
    default = "10.0.0.0/16"
}

variable "subnet_address_space" {
    default = "10.0.1.0/24"
}

variable "machine_name_master" {
    default = "KubeMaster"
}

variable "machine_name_worker" {
    default = "KubeWorker"
}

variable "number_of_workers" {
    default = 1
}

variable "admin_username" {
    default = "ubuntu"
}
