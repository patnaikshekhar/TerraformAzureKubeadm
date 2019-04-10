resource "azurerm_virtual_network" "vnet" {
    name = "${var.rg_name}Vnet"
    location = "${azurerm_resource_group.rg.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    address_space = ["${var.vnet_address_space}"]
}

resource "azurerm_subnet" "subnet" {
    name = "${var.rg_name}Subnet"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix = "${var.subnet_address_space}"
}

resource "azurerm_public_ip" "publicip_master" {
    name = "${var.rg_name}PublicIPMaster"
    location = "${azurerm_resource_group.rg.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    allocation_method = "Dynamic"
}

resource "azurerm_public_ip" "publicip_workers" {
    count = "${var.number_of_workers}"
    name = "${var.rg_name}PublicIPWorker${count.index}"
    location = "${azurerm_resource_group.rg.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    allocation_method = "Dynamic"
}

resource "azurerm_network_security_group" "nsg" {
    name = "${var.rg_name}NSG"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    location="${azurerm_resource_group.rg.location}"

    security_rule {
        name = "ssh"
        priority = 1001
        direction = "Inbound"
        access = "Allow"
        protocol = "TCP"
        source_address_prefix = "*"
        source_port_range = "*"
        destination_address_prefix = "*"
        destination_port_range = "22"
    }
}

resource "azurerm_network_interface" "nic_master" {
    name = "${var.rg_name}MasterNIC"
    location = "${azurerm_resource_group.rg.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    network_security_group_id = "${azurerm_network_security_group.nsg.id}"

    ip_configuration {
        name = "${var.rg_name}MasterNICConfig"
        subnet_id = "${azurerm_subnet.subnet.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id = "${azurerm_public_ip.publicip_master.id}"
    }
}

resource "azurerm_network_interface" "nic_worker" {
    count = "${var.number_of_workers}"
    name = "${var.rg_name}WorkerNIC${count.index}"
    location = "${azurerm_resource_group.rg.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    network_security_group_id = "${azurerm_network_security_group.nsg.id}"

    ip_configuration {
        name = "${var.rg_name}WorkerNICConfig${count.index}"
        subnet_id = "${azurerm_subnet.subnet.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id = "${element(azurerm_public_ip.publicip_workers.*.ip_address, count.index)}"
    }
}


