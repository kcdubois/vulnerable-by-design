resource "random_string" "project" {
  length  = 8
  special = false
  upper   = false
}

data "oci_identity_compartment" "main" {
  id = var.compartment_ocid != "" ? var.compartment_ocid : var.tenancy_ocid
}

data "oci_identity_availability_domains" "main" {
  compartment_id = data.oci_identity_compartment.main.id
}
