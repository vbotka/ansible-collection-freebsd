#!/usr/bin/bash

. ../defaults/batch

# Destroy jails
VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini

# Create template
ansible-playbook pb-iocage-template.yml -i iocage.ini | tee out/out-01.txt

# List templates
ssh admin@$iocage_05 sudo iocage list -lt | tee out/out-02.txt

# Create the project
ansible-playbook vbotka.freebsd.pb_iocage_project_create_from_templates.yml -i iocage.ini -i hosts | tee out/out-03.txt

# List jails
ssh admin@$iocage_05 sudo iocage list -l | tee out/out-04.txt

# Clone repos
ansible-playbook pb-repos.yml -i hosts | tee out/out-05.txt

# List repos
ssh admin@$iocage_05 sudo iocage exec repos ls -la /usr/local/git | tee out/out-06.txt
