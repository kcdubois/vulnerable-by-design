#!/bin/bash

IRIS_VERSION="v2.4.6"

echo "== deploy.sh =="
echo "Installing dependencies..."

apt update -qy && apt install -qy ca-certificates curl git
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo "Add the Docker Apt sources"

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update -qy && apt install -qy docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
usermod -a -G docker ubuntu

echo "Deploy DFIR-IRIS on Docker compose"

cd /opt
git clone -b $IRIS_VERSION https://github.com/dfir-iris/iris-web.git 
chown -R ubuntu:ubuntu iris-web
cd iris-web
cp .env.model .env
docker compose build && docker compose up -d
