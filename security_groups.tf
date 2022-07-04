resource "oci_core_network_security_group" "sg_web" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "sg_web"
}

resource "oci_core_network_security_group_security_rule" "ingress_http" {
  network_security_group_id = oci_core_network_security_group.sg_web.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  stateless                 = false
  tcp_options {
    destination_port_range { 
      max = "80"
      min = "80"
    }
  }
  description = "http only allowed"
}

resource "oci_core_network_security_group_security_rule" "egress_web" {
  network_security_group_id = oci_core_network_security_group.sg_web.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
  stateless                 = false
  description               = "connect to any network"
}

resource "oci_core_network_security_group" "sg_mysql" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "sg_mysql"
}

resource "oci_core_network_security_group_security_rule" "ingress_mysql" {
  network_security_group_id = oci_core_network_security_group.sg_mysql.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  stateless                 = false
  tcp_options {
    destination_port_range { 
      max = "3306"
      min = "3306"
    }
  }
  description = "http only allowed"
}

resource "oci_core_network_security_group_security_rule" "egress_mysql" {
  network_security_group_id = oci_core_network_security_group.sg_mysql.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
  stateless                 = false
  description               = "connect to any network"
}
