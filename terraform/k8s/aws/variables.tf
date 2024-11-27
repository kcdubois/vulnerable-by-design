variable "bucket_prefix" {
    description = "Prefix for the S3 bucket"
    type = string
}

variable "public_key_path" {
    description = "Path to the public key"
    type = string
    default = "~/.ssh/id_rsa.pub"
}