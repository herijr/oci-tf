locals {
  public_subnet_prefix = cidrsubnet(var.vcn_cidr, var.subnet_cidr_offset, 0)
  private_subnet_prefix = cidrsubnet(var.vcn_cidr, var.subnet_cidr_offset, 1)

  ad = data.oci_identity_availability_domain.ad.name

  tcp_protocol  = "6"
  all_protocols = "all"
  anywhere      = "0.0.0.0/0"
}