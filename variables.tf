variable "tenancy_ocid" {
}

variable "user_ocid" {
}

variable "fingerprint" {
}

variable "private_key_path" {
}

variable "compartment_id" {
    type        = string
    description = ""
    default     = "ocid1.compartment.oc1..aaaaaaaamuhy4lyvkjaif5dx4cg4lgjacaysq7tlektb44pvwbs3lo2wxziq"
}

variable "region" {
    type        = string
    description = ""
    default     = "us-ashburn-1"
}

variable "ssh_public_key" {
    type        = string
    description = ""
    default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+oGxxIvdeU4gT3SoIvHPCXwIBSOqT8h6AigJK+75xqts6XJEso9wYF/dSjbnKxOvG5RKiVx6Jo4wEmJ7pX9MFaX0G724fZNhBmTzZJFjSNIyjXCzOeEVi9FLHhK86fGUifidt58d/WlM5Vf/1r533LXnoe+nmdp8Ata3t95T/qeZtI4aJzEdZ35GqUYLoDb2x34YrDiZ848nMIyLktzY6Vs4Zf8EaEOXqrr71f1VJ7h1w1EVO7601wBuoUIqK4PYi9gxoxn2AJTD0lhmdJMTciD8Yxv4ZrX1keJLrE7VG1Qrwa8OjPG84c15eEiRiXzWMlQ5yLpQYx6/LQfZ1uf6F ssh-key-2022-06-05"
}
variable "vcn_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr_offset" {
  default = 5
}

variable "instance_image_id" {
  type = map(string)

  default = {
    # See https://docs.us-phoenix-1.oraclecloud.com/images/
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaawyrwqisciarak2rkykdwbv5u6xsj5bv3nc6nsahk3etad3znz6ea"
  }
}

variable "instance_shape" {
  default = "VM.Standard.E2.1.Micro"
}
