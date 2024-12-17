# Simple infrastructure for AWS

This project is a collection of simple infrastructure resources used for testing and demonstrating the capabilities of various cloud security tools.

## Getting Started

### Clone the repository

To get started, first clone the repository in an environment where both the AWS CLI and Terraform are installed, like AWS CloudShell.

```sh
git clone https://github.com/kcdubois/vulnerable-by-design
cd vulnerable-by-design/terraform/simple/aws
```

### Create a `default.auto.tfvars` file

Create a `default.auto.tfvars` file in the `terraform/simple/aws` directory. This file should contain the following variables:

- `region`: The AWS region to deploy the resources to
- `instance_type`: The AWS instance type to deploy
- `name`: The prefix for the resources deployed in this project

```sh
cat <<EOF > default.auto.tfvars
name = "azvuln"
region = "us-east-1"
instance_type = "t2.micro"
tags = {
  environment = "sandbox"
}
EOF
```

The previous command will create a `default.auto.tfvars` file with default values to get started.

## Deploying the infrastructure

To deploy the infrastructure, run the following command:

```sh
terraform init
terraform apply --auto-approve
```