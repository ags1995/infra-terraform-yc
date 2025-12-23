variable "image_name" {
  description = "OpenStack image name"
  default     = "ununtu-22.04"  # Note: Typo in actual image name!
}

variable "flavor_name" {
  description = "OpenStack flavor (instance type)"
  default     = ""  # Leave empty or find actual flavor
}

variable "network_name" {
  description = "OpenStack network name"
  default     = "sutdents-net"  # Note: Typo "sutdents" not "students"
}

variable "keypair" {
  description = "OpenStack keypair name"
  default     = "Ahmad"  # Your keypair is named "Ahmad"
}
