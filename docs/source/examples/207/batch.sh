#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Destroy jails
# VBOTKA_FREEBSD_BATCH=true \
# ansible-playbook -i iocage.ini --flush-cache \
#                  vbotka.freebsd.pb_iocage_destroy_all_jails.yml

# Templates
ssh admin@iocage_05 iocage list -lt | tee out/out-01.txt
ssh admin@iocage_06 iocage list -lt | tee out/out-02.txt

# Jails
ssh admin@iocage_05 sudo iocage list -l | tee out/out-03.txt
ssh admin@iocage_06 sudo iocage list -l | tee out/out-04.txt

# Create project
ansible-playbook -i hosts -i iocage.ini -e debug=false vbotka.freebsd.pb_iocage_project_create.yml | tee out/out-05.txt

# Graph
ansible-inventory -i hosts --graph | tee out/out-06.txt

# Jails
ssh admin@iocage_05 sudo iocage list -l | tee out/out-07.txt
ssh admin@iocage_06 sudo iocage list -l | tee out/out-08.txt

# Test
ansible-playbook -i hosts pb-test.yml | tee out/out-09.txt

# Destroy project in batch.
if [ "${VBOTKA_FREEBSD_BATCH:-}" = "true" ]; then
    ansible-playbook -i hosts -i iocage.ini -e debug=false vbotka.freebsd.pb_iocage_project_destroy.yml | tee out/out-10.txt
fi
