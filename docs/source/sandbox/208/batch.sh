#!/usr/bin/bash

. ../defaults/batch

# Destroy jails
VBOTKA_FREEBSD_BATCH=true ansible-playbook -i iocage.ini --flush-cache vbotka.freebsd.pb_iocage_destroy_all_jails.yml
ssh admin@iocage_06 sudo iocage destroy -f ansible_client_pull

# Create templates
ansible-playbook -i iocage.ini -e debug=true vbotka.freebsd.pb_iocage_template.yml | tee out/out-01.txt

# List templates
ssh admin@iocage_06 iocage list -lt | tee out/out-02.txt
