#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Stop pkg-repo
ssh admin@iocage_06 sudo iocage stop pkg-repo

# Destroy pkg-repo
ssh admin@iocage_06 sudo iocage destroy -f pkg-repo

# Destroy template
# ssh admin@iocage_06 sudo iocage destroy -f ansible-pkg-repo

# Create template
ansible-playbook -i iocage.ini -e fit_debug=true pb-iocage-template.yml | tee out/out-01.txt

# List templates
ssh admin@iocage_06 sudo iocage list -lt | tee out/out-02.txt

# Create the project
ansible-playbook -i iocage.ini -i hosts vbotka.freebsd.pb_iocage_project_create_from_templates.yml | tee out/out-03.txt

# Inventory graph
ansible-inventory -i hosts --graph | tee out/out-04.txt

# List jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-05.txt

# Fetch packages to repo
ansible-playbook -i hosts -e pkg_debug=true pb-pkg-repo.yml | tee out/out-06.txt

# List repo
ssh admin@iocage_06 fetch -qo - http://172.16.99.23/ | tee out/out-07.txt
