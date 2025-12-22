variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
  default     = "b1g34ocftjh5ugcdgth0"
}

variable "folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
  default     = "b1g1ei0qnal703m46gb2"
}

variable "yc_token" {
  description = "Yandex Cloud OAuth token"
  type        = string
  sensitive   = true
  default     = "y0__xCT2uu1CBjB3RMg8smB4BV11AWg3gGiVQIHmh6Yp2WqyGx4RQ"
}

variable "zone" {
  description = "Yandex Cloud zone"
  type        = string
  default     = "ru-central1-a"
}

variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 1
}
