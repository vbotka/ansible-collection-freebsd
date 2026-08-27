#!/usr/bin/bash

. ../defaults/batch

# Destroy jails
VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini --flush-cache
ssh admin@$iocage_04 sudo iocage destroy -f ansible_client_pull

# Create templates
ansible-playbook vbotka.freebsd.pb_iocage_template.yml -i iocage.ini -e debug=true | tee out/out-01.txt

# List templates
ssh admin@$iocage_04 iocage list -lt | tee out/out-02.txt
