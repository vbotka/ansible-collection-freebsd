#!/usr/bin/bash

. ../defaults/batch

VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini
ssh admin@$iocage_01 iocage list -lt | tee out/out-02.txt
ssh admin@$iocage_02 CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1 iocage list -lt | tee out/out-03.txt

ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml -i iocage.ini -t swarm -e swarm=true -e debug=true | tee out/out-04.txt
ssh admin@$iocage_01 sudo iocage list -l | tee out/out-05.txt
ssh admin@$iocage_02 sudo CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1 iocage list -l | tee out/out-06.txt

ansible-inventory -i hosts --graph | tee out/out-07.txt
ansible-playbook pb-test-01.yml -i hosts | tee out/out-08.txt
