data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_ami" "latest" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/*ubuntu-noble*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "lab" {
  source = "../../modules/lab"

  tags = var.tags
}
