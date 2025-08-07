#!/usr/bin/bash

. ../defaults/batch

VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini
ssh admin@$iocage_02 sudo iocage destroy -f ansible_client
ssh admin@$iocage_04 sudo iocage destroy -f ansible_client
(cd ../202 && ansible-playbook vbotka.freebsd.pb_iocage_template.yml -i iocage.ini)

ssh admin@$iocage_02 sudo iocage list -lt | tee out/out-01.txt
ssh admin@$iocage_04 sudo iocage list -lt | tee out/out-02.txt

ansible-playbook pb-iocage-swarms-create.yml -i iocage.ini | tee out/out-03.txt
ssh admin@$iocage_02 sudo iocage list -l | tee out/out-04.txt
ssh admin@$iocage_04 sudo iocage list -l | tee out/out-05.txt

ansible-playbook pb-test-all.yml -i hosts | tee out/out-06.txt
ansible-playbook pb-test-db.yml -i hosts | tee out/out-07.txt

# ansible-playbook pb-iocage-swarms-destroy.yml -i iocage.ini -i hosts | tee out/out-08.txt
