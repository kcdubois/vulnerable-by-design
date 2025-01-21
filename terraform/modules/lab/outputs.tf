output "name" {
  description = "Name of the project"
  value       = random_pet.name.id
}

output "full_name" {
  description = "Name of the project"
  value       = "${random_pet.name.id}-${random_string.short_id.result}"
}

output "id" {
  value = random_string.lab_id.result
}

output "short_id" {
  value = random_string.short_id.result
}

output "password" {
  value     = random_password.lab_password.result
  sensitive = true
}

output "tags" {
  value = local.tags
}
