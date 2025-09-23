#!/usr/bin/bash

. ../defaults/batch

# destroy
VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini
ssh admin@$iocage_02 sudo iocage destroy -f ansible_client
ssh admin@$iocage_04 sudo iocage destroy -f ansible_client

# create basejails
ansible-playbook pb-iocage-base.yml -i iocage.ini | tee out/out-01.txt
# create clones
ansible-playbook pb-iocage-clone.yml -i iocage.ini | tee out/out-02.txt
# display variables and groups
ansible-playbook pb-all.yml -i hosts --flush-cache | tee out/out-03.txt
# display iocage tags and groups
ansible-playbook pb-ansible-client.yml -i hosts | tee out/out-04.txt
# display all jails
ansible-playbook pb-test.yml -i hosts | tee out/out-05.txt
