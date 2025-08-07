#!/usr/bin/bash

. ../defaults/batch

VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini --flush-cache
ssh admin@$iocage_04 iocage list -lt | tee out/out-01.txt

ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml -i iocage.ini -t clone -e clone=true | tee out/out-02.txt
ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml -i iocage.ini -t swarm -e swarm=true -e debug=true | tee out/out-03.txt
ssh admin@$iocage_04 sudo iocage list -l | tee out/out-04.txt

ansible-inventory -i hosts --graph | tee out/out-05.txt
ansible-playbook pb-test.yml -i hosts | tee out/out-06.txt
