resource "openstack_compute_instance_v2" "vm" {
  name            = "lab5-vm"
  image_name      = var.image_name
  flavor_name     = var.flavor_name
  key_pair        = var.keypair
  security_groups = ["default"]

  network {
    name = var.network_name
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

output "vm_ip" {
  value = openstack_compute_instance_v2.vm.access_ip_v4
}
