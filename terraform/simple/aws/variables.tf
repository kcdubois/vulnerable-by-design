variable "region" {
  type        = string
  description = "AWS region to be used"
  default     = "us-east-1"
}

variable "instance_type" {
  type        = string
  description = "Instance type to be used"
}

variable "cidr_block" {
  type        = string
  description = "CIDR block used for the VPC"
  default     = "172.20.0.0/20"
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to the resources"
  default     = {}
}

variable "admin_username" {
  type    = string
  default = "ubuntu"
}

variable "ssh_key_path" {
  type        = string
  description = "Path to the public key"
  default     = "~/.ssh/id_rsa.pub"
}
