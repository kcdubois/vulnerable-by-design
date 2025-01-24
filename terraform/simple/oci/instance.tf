data "oci_core_image" "ubuntu" {
  image_id = "ocid1.image.oc1.ca-montreal-1.aaaaaaaastk3zbvndrqi6ascjwcw6qjzoa6bn4gm3ntxfhhddwa5d67kgdzq"
}

resource "oci_core_instance" "instance" {
  display_name = "${var.name}-${random_string.project.result}-vm"
  shape        = var.instance_size

  compartment_id      = data.oci_identity_compartment.main.id
  availability_domain = data.oci_identity_availability_domains.main.availability_domains[0].name

  source_details {
    source_id   = data.oci_core_image.ubuntu.id
    source_type = "image"
  }

   create_vnic_details {

        subnet_id = oci_core_subnet.public.id
    }

  metadata = {
    ssh_authorized_keys = file(var.ssh_authorized_keys)
  }
  
}

