#!/bin/bash

#? This script deploys the required software to run pgAdmin, an administrative interface for Postgres databases.

# ==> Setup the repository

# * pgAdmin
curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg
sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'


# ==> Install packages
sudo apt update -qy
sudo apt install -qy apache2 postgresql pgadmin4-web
