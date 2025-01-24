terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  fingerprint  = var.fingerprint
  private_key  = file(var.private_key)
  region       = var.region
}
