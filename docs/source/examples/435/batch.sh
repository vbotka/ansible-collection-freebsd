#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Destroy jails.
ssh admin@iocage_05 sudo iocage destroy -f www-51
ssh admin@iocage_05 sudo iocage destroy -f www-52
ssh admin@iocage_06 sudo iocage destroy -f www-61
ssh admin@iocage_06 sudo iocage destroy -f www-62

# Destroy template.
# ssh admin@iocage_06 sudo iocage destroy -f ansible-nginx

# Create template.
ansible-playbook -i iocage.ini pb-iocage-template.yml | tee out/out-01.txt

# Templates
ssh admin@iocage_05 sudo iocage list -lt | tee out/out-02.txt
ssh admin@iocage_06 sudo iocage list -lt | tee out/out-03.txt

# Project
ansible-playbook -i iocage.ini -i hosts vbotka.freebsd.pb_iocage_project_create_from_templates.yml | tee out/out-04.txt

# Graph
ansible-inventory -i hosts --graph | tee out/out-05.txt

# Jails
ssh admin@iocage_05 sudo iocage list -l | tee out/out-06.txt
ssh admin@iocage_06 sudo iocage list -l | tee out/out-07.txt

# Configure Nginx.
ansible-playbook -i hosts pb-nginx.yml | tee out/out-08.txt

# Test configuration.
ssh admin@iocage_05 sudo iocage exec www-51 service nginx configtest 2>&1 | tee out/out-09.txt
ssh admin@iocage_06 sudo iocage exec www-61 service nginx configtest 2>&1 | tee out/out-10.txt

# Test status.
ssh admin@iocage_05 sudo iocage exec www-51 service nginx status 2>&1 | tee out/out-11.txt
ssh admin@iocage_06 sudo iocage exec www-61 service nginx status 2>&1 | tee out/out-12.txt

# Destroy the jails in batch.
if [ "${VBOTKA_FREEBSD_BATCH:-}" = "true" ]; then
    ssh admin@iocage_05 sudo iocage destroy -f www-51
    ssh admin@iocage_05 sudo iocage destroy -f www-52
    ssh admin@iocage_06 sudo iocage destroy -f www-61
    ssh admin@iocage_06 sudo iocage destroy -f www-62
fi
