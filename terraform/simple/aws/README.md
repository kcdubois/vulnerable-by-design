# Simple infrastructure for AWS

This project is a collection of simple infrastructure resources used for testing and demonstrating the capabilities of various cloud security tools.

## Prerequisite

To be able to deploy this environment to AWS, both **terraform** and **AWS CLI** need to be installed in order to
create the resources and authenticate the AWS provider.

AWS Cloud Shell does not have Terraform installed by default, which can be verified just in case:

```shell
terraform -help
```

### Install terraform

To install Terraform in Cloud Shell, simply follow the steps below or the Terraform documentation.

```shell
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
```

Reference: [https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

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

```hcl
instance_type = "t3.small"
region        = "us-east-1"
cidr_block = "172.20.0.0/20"
public_key_path = "./cloudlabs.pub"
tags = {
  environment = "sandbox"
}
```

Or create the defaults using this handy command:

```shell
cat <<EOF > default.auto.tfvars
instance_type = "t3.small"
region        = "us-east-1"
cidr_block = "172.20.0.0/20"
public_key_path = "./cloudlabs.pub"
tags = {
  environment = "sandbox"
}
EOF
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
eval $(terraform output --raw ssh_connect_command)
```

## Clean up the environment

To remove all created resources when finished with this workspace, simply destroy the environment:

```bash
terraform destroy -auto-approve
```