#!/usr/bin/bash

. ../defaults/batch

# destroy
VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini --flush-cache

# status of templates
ssh admin@$iocage_02 iocage list -lt | tee out/out-01.txt
ssh admin@$iocage_04 iocage list -lt | tee out/out-02.txt

# create swarms
ansible-playbook pb-iocage-ansible-clients-v2.yml -i iocage.ini -t swarm -e swarm=true -e debug=true | tee out/out-03.txt

# status of swarms
ssh admin@$iocage_02 sudo iocage list -l | tee out/out-04.txt
ssh admin@$iocage_04 sudo iocage list -l | tee out/out-05.txt
ansible-inventory -i hosts --graph | tee out/out-06.txt

# test
ansible-playbook pb-test.yml -i hosts --flush-cache | tee out/out-07.txt
ansible-playbook pb-test-filter.yml | tee out/out-pb-test-filter.txt
