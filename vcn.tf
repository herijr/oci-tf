resource "oci_core_vcn" "this" {
  cidr_block     = var.vcn_cidr
  dns_label      = "minhavcn"
  compartment_id = var.compartment_id
  display_name   = "minha-vcn"
}

resource "oci_core_subnet" "public_sn" {
  availability_domain = local.ad
  cidr_block          = "10.0.11.0/24"
  display_name        = "publicsubnet"
  compartment_id      = var.compartment_id
  vcn_id              = oci_core_vcn.this.id
  route_table_id      = oci_core_route_table.public_rt.id

  security_list_ids = [
    oci_core_security_list.public_sl.id
  ]

  dns_label                  = "publicsubnet"
  prohibit_public_ip_on_vnic = false
}

resource "oci_core_subnet" "private_sn" {
  availability_domain = local.ad
  cidr_block          = "10.0.1.0/24"
  display_name        = "privatesubnet"
  compartment_id      = var.compartment_id
  vcn_id              = oci_core_vcn.this.id
  route_table_id      = oci_core_route_table.private_rt.id

  security_list_ids = [
    oci_core_security_list.private_sl.id,
  ]

  dns_label                  = "privatesubnet"
  prohibit_public_ip_on_vnic = true
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

resource "oci_core_route_table" "public_rt" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "public-rt"

  route_rules {
    destination       = local.anywhere
    network_entity_id = oci_core_internet_gateway.ig.id
  }
}

resource "oci_core_route_table" "private_rt" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "private-rt"

  route_rules {
    destination       = local.anywhere
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat_gateway.id
  }
}

resource "oci_core_security_list" "public_sl" {
  compartment_id = var.compartment_id
  display_name   = "public security list"
  vcn_id         = oci_core_vcn.this.id
  
  ingress_security_rules {
    protocol    = "all"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
  }
 
  egress_security_rules {
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
    stateless        = false
  }

}

resource "oci_core_security_list" "private_sl" {
  compartment_id = var.compartment_id
  display_name   = "private security list"
  vcn_id         = oci_core_vcn.this.id

  ingress_security_rules {
    protocol    = "all"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
  }
 
  egress_security_rules {
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
    stateless        = false
  }
}
