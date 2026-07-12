#!/usr/bin/bash

. ../defaults/batch

# Destroy jails
VBOTKA_FREEBSD_BATCH=true -i iocage.ini ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml
ssh admin@iocage_06 sudo iocage destroy -f ansible_client_apache

# Create pkglist file
ansible-playbook -i iocage.ini pb-pkglist.yml | tee out/out-01.txt

# Create template ansible_client_apache
ansible-playbook -i iocage.ini vbotka.freebsd.pb_iocage_template.yml | tee out/out-02.txt

# List templates
ssh admin@iocage_06 iocage list -lt | tee out/out-03.txt
