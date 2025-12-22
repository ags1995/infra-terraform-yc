terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "~> 0.129.0"
    }
  }
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

# Create a VPC network
resource "yandex_vpc_network" "network" {
  name = "lab5-network"
}

# Create a subnet in the specified zone
resource "yandex_vpc_subnet" "subnet" {
  name           = "lab5-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# Create VM instances
resource "yandex_compute_instance" "vm" {
  count = var.vm_count
  name = "lab5-vm-${count.index}"
  
  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd87va5cc00gaq2f5qfb"  # Ubuntu 22.04
      size = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }
  
  scheduling_policy {
    preemptible = true  # Cheaper, can be terminated
  }
}

# Output the public IP addresses
output "vm_public_ips" {
  value = yandex_compute_instance.vm[*].network_interface[0].nat_ip_address
  description = "Public IP addresses of created VMs"
}

# Output SSH command examples
output "ssh_commands" {
  value = [for i, ip in yandex_compute_instance.vm[*].network_interface[0].nat_ip_address : "ssh ubuntu@${ip}"]
  description = "SSH commands to connect to VMs"
}
