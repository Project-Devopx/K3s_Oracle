resource "oci_identity_compartment" "k3s_dev" {
  compartment_id = var.tenancy_ocid
  name           = "k3s-dev"
  description    = "Development compartment for K3s"
}
