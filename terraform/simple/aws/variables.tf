variable "region" {
  type = string
  description = "AWS region to be used"
  default = "us-east-1"
}

variable "instance_type" {
  type = string
  description = "Instance type to be used"
}

variable "name" {
  type = string
  description = "Name of the resources"
}

variable "tags" {
  type = map(string)
  description = "Tags to be applied to the resources"
  default = {}
}

variable "cidr_block" {
  type = string
  description = "CIDR block to be used"
  default = "10.0.0.0/16"
}

variable "public_key_path" {
  type = string
  description = "Path to the public key"
  default = "~/.ssh/id_rsa.pub"
}