variable "service_account_key_file" {
  description = "Path to Yandex Cloud Service Account key file"
  type        = string
  default     = "../credentials/sa-key.json"
}
variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
}
variable "folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
}
variable "zone" {
  description = "Yandex Cloud zone"
  type        = string
  default     = "ru-central1-a"
}
variable "image_id" {
  description = "Yandex Cloud image ID"
  type        = string
  default     = "fd80ok8sil1fn2gqbm6h"
}
variable "vm_user" {
  description = "VM SSH user"
  type        = string
  default     = "ubuntu"
}
variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/jenkins_deploy_rsa.pub"
}
