#!/usr/bin/bash

. ../defaults/batch

# destroy
VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini --flush-cache
ssh admin@$iocage_02 sudo iocage destroy -f ansible_client
ssh admin@$iocage_04 sudo iocage destroy -f ansible_client

# create templates
ansible-playbook vbotka.freebsd.pb_iocage_template.yml -i iocage.ini --flush-cache | tee out/out-01.txt

# of status templates
ssh admin@$iocage_02 sudo iocage list -lt | tee out/out-02.txt
ssh admin@$iocage_04 sudo iocage list -lt | tee out/out-03.txt

# create clones
ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml -i iocage.ini -t clone -e clone=true --flush-cache | tee out/out-04.txt

# status of clones
ssh admin@$iocage_02 sudo iocage list -l | tee out/out-05.txt
ssh admin@$iocage_04 sudo iocage list -l | tee out/out-06.txt
ansible-inventory -i hosts --graph | tee out/out-07.txt

# test
ansible-playbook pb-test.yml -i hosts --flush-cache | tee out/out-08.txt
