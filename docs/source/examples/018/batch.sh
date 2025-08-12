#!/usr/bin/bash

. ../defaults/batch

# destroy
VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini
ssh admin@$iocage_02 sudo iocage destroy -f ansible_client
ssh admin@$iocage_04 sudo iocage destroy -f ansible_client

# prepare
(cd ../010 && ansible-playbook pb-iocage-fetch-base-clone-list.yml -i iocage.ini -t create)

# status of jails
ssh admin@$iocage_02 sudo iocage list -l | tee out/out-01.txt
ssh admin@$iocage_04 sudo iocage list -l | tee out/out-02.txt

# create jails
ansible-playbook pb-iocage-clone-list.yml -i iocage.ini | tee out/out-03.txt

# status of jails
ssh admin@$iocage_02 sudo iocage list -l | tee out/out-04.txt
ssh admin@$iocage_04 sudo iocage list -l | tee out/out-05.txt
ansible-inventory -i iocage.yml --list --yaml | tee out/out-06.txt

# test
ansible-playbook pb-test.yml -i iocage.yml  | tee out/out-07.txt
ssh admin@$iocage_02 sudo iocage stop test_112 test_113
ssh admin@$iocage_02 sudo iocage list -l | tee out/out-08.txt
ansible-playbook pb-test.yml -i iocage.yml | tee out/out-09.txt
