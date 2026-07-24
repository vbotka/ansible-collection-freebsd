#!/usr/bin/bash

. ../defaults/batch

# Stop repos and repos-devel
# ssh admin@iocage_06 sudo iocage stop repos
# ssh admin@iocage_06 sudo iocage stop repos-devel

# Destroy repos and repos-devel
ssh admin@iocage_06 sudo iocage destroy -f repos
ssh admin@iocage_06 sudo iocage destroy -f repos-devel

# Destroy template
ssh admin@iocage_06 sudo iocage destroy -f ansible-repos

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

# Clone repos
ansible-playbook -i hosts pb-repos.yml | tee out/out-06.txt

# List repos
ssh admin@iocage_06 sudo iocage exec repos ls -la /usr/local/git | tee out/out-07.txt
