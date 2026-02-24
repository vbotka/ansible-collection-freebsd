#!/usr/bin/bash

. ../defaults/batch

# destroy
VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini --flush-cache
ssh admin@$iocage_04 sudo iocage destroy -f ansible_client_apache

# create pkglist file
ansible-playbook pb-pkglist.yml -i iocage.ini | tee out/out-01.txt

# create template ansible_client_apache
ansible-playbook vbotka.freebsd.pb_iocage_template.yml -i iocage.ini | tee out/out-02.txt
