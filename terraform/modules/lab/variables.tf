variable "tags" {
  type        = map(string)
  description = "Map of tags to generate"
  default     = {}
}

variable "prefix" {
  type        = string
  description = "Prefix used for lab name"
  default     = "lab"
}

variable "separator" {
  type        = string
  description = "Separator character used for project name creation (ex: charming-ray)"
  default     = "-"
}
