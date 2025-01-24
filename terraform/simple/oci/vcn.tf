resource "oci_core_vcn" "main" {
  compartment_id = data.oci_identity_compartment.main.id
  display_name   = "${var.name}-${random_string.project.result}-vcn"
  cidr_block     = var.cidr_block
}

resource "oci_core_subnet" "public" {
  vcn_id         = oci_core_vcn.main.id
  compartment_id = data.oci_identity_compartment.main.id
  cidr_block     = cidrsubnet(var.cidr_block, 8, 1)
  display_name   = "public"
}
