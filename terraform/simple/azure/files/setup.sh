#!/bin/bash

echo "== Starting setup.sh=="

apt update -qy && apt install -qy git
cd /opt
git clone https://github.com/kcdubois/vulnerable-by-design
