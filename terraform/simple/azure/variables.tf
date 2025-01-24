variable "subscription_id" {
  type = string
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "instance_type" {
  type    = string
  default = "D2_v3"
}

variable "name" {
  type    = string
  default = "simple-ec2"
}

variable "admin_username" {
  type        = string
  description = "Username for administrative purposes"
  default     = "cloudlabs"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "ssh_key_path" {
  type    = string
  default = "~/id_rsa.pub"
}
