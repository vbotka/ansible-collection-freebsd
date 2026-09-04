#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Destroy www-01 and www-02
ssh admin@iocage_06 sudo iocage destroy -f www-01
ssh admin@iocage_06 sudo iocage destroy -f www-02

# Destroy template
# ssh admin@iocage_06 sudo iocage destroy -f ansible-nginx

# Create template
ansible-playbook -i iocage.ini pb-iocage-template.yml | tee out/out-01.txt

# List templates
ssh admin@iocage_06 sudo iocage list -lt | tee out/out-02.txt

# Create the project
ansible-playbook -i iocage.ini -i hosts vbotka.freebsd.pb_iocage_project_create_from_templates.yml | tee out/out-03.txt

# Inventory graph
ansible-inventory -i hosts --graph | tee out/out-04.txt

# List jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-05.txt

# Configure Nginx servers
ansible-playbook -i hosts pb-nginx.yml | tee out/out-06.txt
