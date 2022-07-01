resource "oci_core_instance" "instancia01" {
  availability_domain = local.ad
  compartment_id      = var.compartment_id
  display_name        = "instancia-publica"
  shape               = var.instance_shape

  source_details {
    source_id   = var.instance_image_id[var.region]
    source_type = "image"
  }

  create_vnic_details {
    subnet_id = oci_core_subnet.public_sn.id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

  timeouts {
    create = "10m"
  }
}

resource "oci_core_subnet" "private" {
  availability_domain = local.ad
  cidr_block          = local.private_subnet_prefix
  display_name        = "instancia-privada"
  compartment_id      = var.compartment_id
  vcn_id              = oci_core_vcn.this.id
  route_table_id      = oci_core_route_table.private.id

  security_list_ids = [
    oci_core_security_list.private.id,
  ]

  dns_label                  = "private"
  prohibit_public_ip_on_vnic = true
}
