# Simple infrastructure for Azure

This project is a collection of simple infrastructure resources used for testing and demonstrating the capabilities of various cloud security tools.

## Getting Started

Create a `default.auto.tfvars` file in the `terraform/simple/azure` directory. This file should contain the following variables:

- `subscription_id`: The Azure subscription ID
- `location`: The Azure region to deploy the resources to
- `instance_type`: The Azure instance type to deploy
- `name`: The prefix for the resources deployed in this project

```hcl
name = "azvuln"
subscription_id = "00000000-0000-0000-0000-000000000000"
location = "eastus"
instance_type = "Standard_B1s"
tags = {
  environment = "sandbox"
}
```

## Deploying the infrastructure

To deploy the infrastructure, run the following command:

```sh
terraform init
terraform apply --auto-approve
```