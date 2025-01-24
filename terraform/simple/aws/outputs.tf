output "instance_public_ip" {
  value = aws_instance.main.public_ip
}

output "instance_public_dns" {
  value = aws_instance.main.public_dns
}

output "instance_private_ip" {
  value = aws_instance.main.private_ip
}

output "admin_username" {
  value = var.admin_username
}

output "ssh_connect_command" {
  value = "ssh -i ./cloudlabs -o StrictHostKeyChecking=no ${var.admin_username}@${aws_instance.main.public_dns}"
}
