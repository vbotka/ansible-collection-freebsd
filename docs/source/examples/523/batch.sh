#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Destroy repos and repos-devel
ssh admin@iocage_05 sudo iocage destroy -f repos
ssh admin@iocage_05 sudo iocage destroy -f repos-devel
ssh admin@iocage_06 sudo iocage destroy -f repos
ssh admin@iocage_06 sudo iocage destroy -f repos-devel

# Destroy template
# ssh admin@iocage_06 sudo iocage destroy -f ansible-repos

# Create template
ansible-playbook -i iocage.ini pb-iocage-template.yml | tee out/out-01.txt

# List templates
ssh admin@iocage_05 sudo iocage list -lt | tee out/out-02.txt
ssh admin@iocage_06 sudo iocage list -lt | tee out/out-03.txt

# Create the project
ansible-playbook -i iocage.ini -i hosts vbotka.freebsd.pb_iocage_project_create_from_templates.yml | tee out/out-04.txt

# Graph
ansible-inventory -i hosts --graph | tee out/out-06.txt

# Jails
ssh admin@iocage_05 sudo iocage list -l | tee out/out-07.txt
ssh admin@iocage_06 sudo iocage list -l | tee out/out-08.txt

# Clone repos
ansible-playbook -i hosts/05_iocage2.yml pb-repos.yml | tee out/out-09.txt
ansible-playbook -i hosts/06_iocage2.yml pb-repos.yml | tee out/out-10.txt

# Repos
ssh admin@iocage_05 sudo iocage exec repos ls -la /usr/local/git | tee out/out-11.txt
ssh admin@iocage_06 sudo iocage exec repos ls -la /usr/local/git | tee out/out-12.txt
