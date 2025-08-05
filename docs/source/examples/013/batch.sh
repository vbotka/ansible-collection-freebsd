#!/usr/bin/bash

. ../defaults/batch

VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini
ssh admin@$iocage_02 sudo CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1 iocage destroy -f ansible_client
ssh admin@$iocage_04 sudo CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1 iocage destroy -f ansible_client

ansible-playbook pb-iocage-base.yml -i iocage.ini | tee out/out-01.txt
ansible-playbook pb-iocage-clone.yml -i iocage.ini | tee out/out-02.txt
ansible-playbook pb-all.yml -i hosts | tee out/out-03.txt
ansible-playbook pb-ansible-client.yml -i hosts | tee out/out-04.txt
ansible-playbook pb-test.yml -i hosts | tee out/out-05.txt
