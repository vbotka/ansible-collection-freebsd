#!/usr/bin/bash

. ../defaults/batch

VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini
(cd ../010 && ansible-playbook pb-iocage-fetch-base-clone-list.yml -i iocage.ini -t create)

ssh admin@$iocage_02 sudo iocage list -l | tee out/out-01.txt
ssh admin@$iocage_04 sudo iocage list -l | tee out/out-02.txt

ansible-playbook pb-iocage-clone-list.yml -i iocage.ini | tee out/out-03.txt
ssh admin@$iocage_02 sudo iocage list -l | tee out/out-04.txt
ssh admin@$iocage_04 sudo iocage list -l | tee out/out-05.txt

ansible-inventory -i iocage.yml --list --yaml | tee out/out-06.txt
ansible-playbook pb-test.yml -i iocage.yml  | tee out/out-07.txt
ssh admin@$iocage_02 sudo iocage list -l | tee out/out-08.txt

ssh admin@$iocage_02 sudo iocage stop test_112 test_113
ansible-playbook pb-test.yml -i iocage.yml | tee out/out-09.txt
