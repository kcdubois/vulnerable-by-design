output "vm_password" {
  value     = random_password.admin_password.result
  sensitive = true
}

output "vm_private_ip" {
  value = azurerm_network_interface.vm_nic.private_ip_address
  description = "The private IP address assigned to the virtual machine"
}

output "vm_public_ip" {
  value = azurerm_public_ip.vm_public_ip.ip_address
  description = "The public IP address assigned to the virtual machine"
}

output "sp_client_id" {
  value = azuread_application.sp.id
}

output "sp_client_secret" {
  value = azuread_service_principal_password.sp_password.value
  sensitive = true
}
