output "vm_public_ip" {
  description = "Public IP address of the created VM"
  value       = yandex_compute_instance.vm.network_interface[0].nat_ip_address
}
output "vm_private_ip" {
  description = "Private IP address of the created VM"
  value       = yandex_compute_instance.vm.network_interface[0].ip_address
}
