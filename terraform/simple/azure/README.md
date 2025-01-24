# Simple infrastructure for Azure

This project is a collection of simple infrastructure resources used for testing and demonstrating the capabilities of various cloud security tools.

## Getting Started

### Generate SSH key if not already present

For authentication, SSH keys can be used to for public key authentication with the deployed virtual machine.

To generate a new key pair, issue the following command:

```shell
ssh-keygen -t rsa -b 4096 -f ./cloudlabs -N "" -q
```

This will generate the files `cloudlabs` and `cloudlabs.pub`, which are the private and public key respectfully.

### Create a new variable file

Create a `default.auto.tfvars` file in the `terraform/simple/azure` directory. This file should contain the following variables:

- `subscription_id`: The Azure subscription ID
- `location`: The Azure region to deploy the resources to
- `instance_type`: The Azure instance type to deploy
- `name`: The prefix for the resources deployed in this project
- `ssh_key_path`: Path to the SSH public key created earlier

```hcl
name = "azvuln"
location = "eastus"
instance_type = "Standard_B1s"
ssh_key_path = "./cloudlabs.pub"
tags = {
  environment = "sandbox"
}
```

Or create the defaults using this handy command:

```shell
cat <<EOF > default.auto.tfvars
name = "azvuln"
location = "eastus"
instance_type = "Standard_B1s"
ssh_key_path = "./cloudlabs.pub"
tags = {
  environment = "sandbox"
}
EOF
```

Add your subscription ID to the file from the Azure CLI configuration 

```shell
echo "subscription_id = $(az account show --query 'id')" >> default.auto.tfvars
```

## Deploying the infrastructure

To deploy the infrastructure, run the following command:

```sh
terraform init
terraform apply --auto-approve
```

## Connecting to the infrastructure

An easy way to connect to the infrastructure is with the use of the Terraform outputs and the public key authentication
to use some shell magic to connect to the newly created virtual machine:

```shell
ssh -i ./cloudlabs -o HostKeyChecking=no $(terraform output --raw admin_username)@$(terraform output --raw vm_public_ip)
```

## Retrieve the VM's IP address and administrative password

To get the sensitive values of the newly created virtual machine, issue the following Terraform command:

```bash
terrafrom output main
```

## Clean up the environment

To remove all created resources when finished with this workspace, simply destroy the environment:

```bash
terraform destroy -auto-approve
```