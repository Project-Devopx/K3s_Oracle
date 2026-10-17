# Create control plane and worker nodes in the K3s cluster
locals {
  instance_type = "VM.Standard.A1.Flex"
}

data "oci_core_images" "ubuntu" {
  compartment_id           = oci_identity_compartment.k3s_dev.id
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "24.04"
  shape                    = "VM.Standard.A1.Flex"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}



resource "oci_core_instance" "instance" {
  for_each = toset(["control-plane", "worker"])

  compartment_id      = oci_identity_compartment.k3s_dev.id
  availability_domain = var.availability_zone
  shape               = local.instance_type
  display_name        = each.key

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu.images[0].id
  }

  shape_config {
    memory_in_gbs = 6
    ocpus         = 1
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.public_subnet.id
    assign_public_ip = true
    assign_private_dns_record = true 
    display_name     = "${each.key}-vnic"
  }

  metadata = {
    ssh_authorized_keys = file("~/.ssh/id_rsa.pub")
  }
}

output "instance_ips" {
  value = { for instance in oci_core_instance.instance : instance.display_name => { 
    public_ip = instance.public_ip,
    private_ip = instance.private_ip

    }
  }
}

