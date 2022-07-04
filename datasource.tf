data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 3
}

data "oci_core_images" "_" {
  compartment_id           = var.compartment_id
  shape                    = var.instance_shape
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "20.04"
}