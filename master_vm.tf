resource "azurerm_virtual_machine" "kubemaster" {
    name = "${var.machine_name_master}"
    location = "${azurerm_resource_group.rg.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    network_interface_ids = ["${azurerm_network_interface.nic_master.id}"]
    vm_size = "Standard_DS1_v2"
    delete_os_disk_on_termination = false

    storage_os_disk {
        name = "${var.machine_name_master}Disk"
        caching = "ReadWrite"
        create_option = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "18.04-LTS"
        version = "latest"
    }

    os_profile {
        computer_name = "${var.machine_name_master}"
        admin_username = "${var.admin_username}"
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            key_data = "${file("~/.ssh/id_rsa.pub")}"
            path = "/home/${var.admin_username}/.ssh/authorized_keys"
        }
    }

    connection {
        type = "ssh"
        user = "${var.admin_username}"
        port = "22"
        private_key = "${file("~/.ssh/id_rsa")}"
    }

    provisioner "file" {
        source = "config/install.sh"
        destination = "/home/${var.admin_username}/install.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x ./install.sh",
            "./install.sh"
        ]
    }
}