resource "oci_core_vcn" "k3s_vcn" {
  compartment_id = oci_identity_compartment.k3s_dev.id
  cidr_blocks    = ["10.0.0.0/16"]
  display_name   = "k3s-vcn"
  dns_label      = "k3s"
}

resource "oci_core_route_table" "igw_rt" {
  compartment_id = oci_identity_compartment.k3s_dev.id
  vcn_id         = oci_core_vcn.k3s_vcn.id
  display_name   = "igw-rt"

  route_rules {
    network_entity_id = oci_core_internet_gateway.k3s_igw.id
    destination       = "0.0.0.0/0"
  }
}

resource "oci_core_internet_gateway" "k3s_igw" {
  compartment_id = oci_identity_compartment.k3s_dev.id
  vcn_id         = oci_core_vcn.k3s_vcn.id
  display_name   = "k3s-igw"
  enabled        = true
}


resource "oci_core_subnet" "public_subnet" {
  compartment_id = oci_identity_compartment.k3s_dev.id
  vcn_id         = oci_core_vcn.k3s_vcn.id
  route_table_id = oci_core_route_table.igw_rt.id
  availability_domain = var.availability_zone
  security_list_ids = [oci_core_security_list.public_sl.id]
  cidr_block     = "10.0.1.0/24"
  display_name   = "k3s-public-subnet"
}

resource "oci_core_security_list" "public_sl" {
  compartment_id = oci_identity_compartment.k3s_dev.id
  vcn_id         = oci_core_vcn.k3s_vcn.id
  display_name   = "k3s-public-sl"

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

  # Allow SSH (Restricted via variable)
  ingress_security_rules {
    protocol = "6"
    source   = var.my_ip_address
    tcp_options {
      min = 22
      max = 22
    }
  }

  # Allow HTTP
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 80
      max = 80
    }
  }

  # Allow HTTPS
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 443
      max = 443
    }
  } 
  
  # Reach API Server (K3s Control Plane) on port 6443
  ingress_security_rules {
    protocol = "6"
    source   = var.my_ip_address
    tcp_options {
      min = 6443
      max = 6443
    }
  }

  # Allow internal VCN traffic
  ingress_security_rules {
    protocol = "all"
    source   = "10.0.0.0/16"
  }
}

# resource "oci_core_subnet" "private_subnet" {
#   compartment_id = oci_identity_compartment.k3s_dev.id
#   vcn_id         = oci_core_vcn.k3s_vcn.id
#   availability_domain = var.availability_zone
#   cidr_block     = "10.0.2.0/24"
#   display_name   = "k3s-private-subnet"
# }

