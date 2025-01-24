variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID"
}

variable "location" {
  type        = string
  description = "The Azure region to deploy resources in"
  default     = "eastus"
}

variable "instance_size" {
  type        = string
  description = "Instance size used for AKS nodes"
  default     = "Standard_B2s"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the resources"
  default     = {}
}
