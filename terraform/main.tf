data "yandex_vpc_network" "default" {
  name = "default"
}
data "yandex_vpc_subnet" "default" {
  name = "default-ru-central1-a"
}
resource "yandex_compute_instance" "vm" {
  name        = "jenkins-vm"
  platform_id = "standard-v3"
  zone        = var.zone
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = 10
    }
  }
  network_interface {
    subnet_id = data.yandex_vpc_subnet.default.id
    nat       = true
  }
  metadata = {
    ssh-keys = "${var.vm_user}:${file(var.ssh_public_key_path)}"
  }
}
