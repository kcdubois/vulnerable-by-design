output "main" {
  value = templatefile("${path.module}/files/output.tftpl", {
    admin_username = var.admin_username
    admin_password = module.lab.password
    project_name   = module.lab.full_name
    vm_public_ip   = azurerm_public_ip.vm_public_ip.ip_address
  })

  sensitive = true

}

output "admin_username" {
  value = var.admin_username
}

output "vm_public_ip" {
  value = azurerm_public_ip.vm_public_ip.ip_address
}
