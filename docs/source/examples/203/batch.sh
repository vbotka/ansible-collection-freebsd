#!/usr/bin/bash

. ../defaults/batch

# destroy
VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini --flush-cache

# create templates
(cd ../202 && ansible-playbook vbotka.freebsd.pb_iocage_template.yml -i iocage.ini --flush-cache)

# status of templates
ssh admin@$iocage_02 iocage list -lt | tee out/out-01.txt
ssh admin@$iocage_04 iocage list -lt | tee out/out-02.txt

# create swarms
ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml -i iocage.ini -t swarm -e swarm=true -e debug=true --flush-cache | tee out/out-03.txt

# status of swarms
ssh admin@$iocage_02 sudo iocage list -l | tee out/out-04.txt
ssh admin@$iocage_04 sudo iocage list -l | tee out/out-05.txt
ansible-inventory -i hosts --graph | tee out/out-06.txt

# test
ansible-playbook pb-test.yml -i hosts  --flush-cache | tee out/out-07.txt
