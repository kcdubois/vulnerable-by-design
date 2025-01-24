variable "tenancy_ocid" {
  type        = string
  description = "The OCID of the tenancy"
}

variable "compartment_ocid" {
  type        = string
  description = "The OCID of the compartment"
  default     = ""
}

variable "user_ocid" {
  type        = string
  description = "The OCID of the user"
}

variable "fingerprint" {
  type        = string
  description = "The fingerprint of the API key"
}

variable "private_key" {
  type        = string
  description = "The private key path of the API key"
  default     = "~/.oci/oci_api_key.pem"
}

variable "region" {
  type    = string
  default = "ca-toronto-1"
}

variable "name" {
  type    = string
  default = "ocilab"
}

variable "instance_size" {
  type    = string
  default = "VM.Standard.A1.Flex"
}

variable "ssh_authorized_keys" {
  type        = string
  description = "The SSH authorized keys"
  default     = "~/.ssh/id_rsa.pub"
}

# Networking
variable "cidr_block" {
  type        = string
  description = "CIDR block used for the VCN"
  default     = "172.16.0.0/16"
}
