resource "oci_core_vcn" "this" {
  cidr_block     = var.vcn_cidr
  dns_label      = "pp"
  compartment_id = var.compartment_id
  display_name   = "minha-vcn"
}

resource "oci_core_nat_gateway" "nat_gateway" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "nat_gateway"
}

resource "oci_core_internet_gateway" "ig" {
  compartment_id = var.compartment_id
  display_name   = "meu-igw"
  vcn_id         = oci_core_vcn.this.id
}

resource "oci_core_subnet" "public_sn" {
  availability_domain = local.ad
  cidr_block          = local.public_subnet_prefix
  display_name        = "subnet publica"
  compartment_id      = var.compartment_id
  vcn_id              = oci_core_vcn.this.id
  route_table_id      = oci_core_route_table.public_rt.id

  security_list_ids = [
    oci_core_security_list.public_sl.id
  ]

  dns_label                  = "subnetpublica"
  prohibit_public_ip_on_vnic = false
}

resource "oci_core_route_table" "public_rt" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "public-rt"

  route_rules {
    destination       = local.anywhere
    network_entity_id = oci_core_internet_gateway.ig.id
  }
}

resource "oci_core_security_list" "public_sl" {
  compartment_id = var.compartment_id
  display_name   = "security list publica"
  vcn_id         = oci_core_vcn.this.id

  ingress_security_rules {
    source   = local.anywhere
    protocol = local.tcp_protocol

    tcp_options {
      min = 22
      max = 22
    }
  }

  egress_security_rules {
    destination = var.vcn_cidr
    protocol    = local.tcp_protocol

    tcp_options {
      min = 22
      max = 22
    }
  }
}


resource "oci_core_route_table" "private" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "private"

  route_rules {
    destination       = local.anywhere
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat_gateway.id
  }
}

resource "oci_core_security_list" "private" {
  compartment_id = var.compartment_id
  display_name   = "private"
  vcn_id         = oci_core_vcn.this.id

  ingress_security_rules {
    source   = local.public_subnet_prefix
    protocol = local.tcp_protocol

    tcp_options {
      min = 22
      max = 22
    }
  }

  egress_security_rules {
    destination = local.anywhere
    protocol    = local.all_protocols
  }
}

resource "oci_core_instance" "private" {
  availability_domain = local.ad
  compartment_id      = var.compartment_id
  display_name        = "private_test_instance"
  shape               = var.instance_shape

  source_details {
    source_id   = var.instance_image_id[var.region]
    source_type = "image"
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.private.id
    assign_public_ip = false
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

  timeouts {
    create = "10m"
  }
}
