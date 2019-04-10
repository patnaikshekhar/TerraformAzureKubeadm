output "masterip" {
    value = "${azurerm_public_ip.publicip_master.ip_address}"
}