module "lab" {
  source = "../"
}

output "name" {
  value = module.lab.name
}

output "id" {
  value = module.lab.id
}

output "short_id" {
  value = module.lab.short_id
}

output "full_name" {
  value = module.lab.full_name
}

output "tags" {
  value = module.lab.tags
}

output "password" {
  value     = module.lab.password
  sensitive = true
}
