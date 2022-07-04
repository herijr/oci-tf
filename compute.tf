resource "oci_core_instance" "web" {
  availability_domain = local.ad
  compartment_id      = var.compartment_id
  display_name        = "web"
  shape               = var.instance_shape

  shape_config {
    memory_in_gbs = var.memory_in_gbs_per_node
    ocpus         = var.ocpus_per_node
  }

  source_details {
    source_id   = data.oci_core_images._.images[0].id
    source_type = "image"
  }

  create_vnic_details {
    subnet_id = oci_core_subnet.public_sn.id
    nsg_ids = [oci_core_network_security_group.sg_web.id]
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

  timeouts {
    create = "10m"
  }
}

resource "oci_core_instance" "mariadb" {
  availability_domain = local.ad
  compartment_id      = var.compartment_id
  display_name        = "mariadb"
  shape               = var.instance_shape

  shape_config {
    memory_in_gbs = var.memory_in_gbs_per_node
    ocpus         = var.ocpus_per_node
  }

  source_details {
    source_id   = data.oci_core_images._.images[0].id
    source_type = "image"
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.private_sn.id
    nsg_ids = [oci_core_network_security_group.sg_mysql.id]
    assign_public_ip = false
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

  timeouts {
    create = "10m"
  }
}
