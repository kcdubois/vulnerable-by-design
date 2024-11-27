#!/bin/bash

SSH_KEY_TYPE="rsa"
SSH_KEY_BITS="4096"
SSH_KEY_FILE_NAME="id_lab"

function generate_ssh_key() {
    echo "Generating SSH key for Terraform resources"

    ssh-keygen -t $SSH_KEY_TYPE -b $SSH_KEY_BITS -f ./$SSH_KEY_FILE_NAME -N ""

    echo "New SSH key pair generated: $SSH_KEY_FILE_NAME"
}

function deploy_terraform_workspace(){
    # deploy_terraform_workspace <azure|aws> <simple-ec2>
    echo "Deploying Terraform workspace"

    cd ./terraform/$1/$2
    terraform init
    terraform apply -auto-approve
}


ROOT_DIR=$(pwd)
generate_ssh_key
deploy_terraform_workspace "simple" "azure"