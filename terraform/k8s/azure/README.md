# Kubernetes infrastructure for Azure

This project deploys a Kubernetes cluster through Azure Kubernetes Services and deploys a simple app on top of it.

## Getting Started

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
instance_size = "Standard_D2s_v3"
ssh_key_path = "./cloudlabs.pub"
tags = {
  environment = "sandbox"
}
```

Or create the defaults using this handy command:

```shell
cat <<EOF > default.auto.tfvars
location = "eastus"
instance_size = "Standard_D2s_v3"
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

Once the Kubernetes cluster is available, the next step is to configure the local `kubectl` client to talk to your
cluster. This simple command should allow you to do so.

```shell
eval $(terraform output --raw aks_connect_command)
```

You should see a message about a merged configuration to your home folder.

### Deploying the Kubernetes app

With the `kubectl` client configured, go into the `k8s` folder to deploy the app:

```shell
cd ../../../k8s/tasky
kubectl apply -f .
```

To retrieve the public IP address of the new app:

```shell
kubectl get svc tasky-service
```

## Clean up the environment

To remove all created resources when finished with this workspace, simply destroy the environment:

```bash
terraform destroy -auto-approve
```