#!/usr/bin/bash

. ../defaults/batch

# destroy
VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini --flush-cache
ssh admin@$iocage_04 sudo iocage destroy -f ansible_client

# create templates
ansible-playbook vbotka.freebsd.pb_iocage_template.yml -i iocage.ini -e debug=true | tee out/out-01.txt

# test
ansible-playbook pb-test.yml -i iocage.ini | tee out/out-02.txt
