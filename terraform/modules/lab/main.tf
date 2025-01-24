locals {
  tags = merge(
    var.tags,
    {
      lab_id       = random_string.lab_id.result,
      managed_by   = "terraform",
      project_name = random_pet.name.id
    }
  )
}

resource "random_string" "lab_id" {
  length  = 12
  upper   = false
  numeric = true
  special = false
}

resource "random_string" "short_id" {
  length  = 4
  upper   = false
  numeric = true
  special = false
}

resource "random_password" "lab_password" {
  length      = 24
  upper       = true
  lower       = true
  special     = true
  numeric     = true
  min_special = 2
  min_upper   = 2
  min_numeric = 2
}

resource "random_pet" "name" {
  separator = var.separator
  length    = 2
}

