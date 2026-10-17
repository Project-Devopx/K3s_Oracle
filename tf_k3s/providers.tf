terraform {
  required_version = ">= 1.0.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "9.9.0"
    }
  }
  backend "oci" {
    bucket = "tf-k3s-state"
    namespace = "id05wce7w7l5"
    key = "terraform.tfstate"
    region = "us-ashburn-1"
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}


