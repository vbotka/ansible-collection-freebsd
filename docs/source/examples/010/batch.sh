#!/usr/bin/bash

. ../defaults/batch

# destroy
VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini
ssh admin@$iocage_02 sudo CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1 iocage destroy -f ansible_client
ssh admin@$iocage_04 sudo CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1 iocage destroy -f ansible_client

# create jails
ansible-playbook pb-iocage-fetch-base-clone-list.yml -i iocage.ini | tee out/out-01.txt

# status of jails
ssh admin@$iocage_02 sudo iocage list -l | tee out/out-02.txt
ssh admin@$iocage_04 sudo iocage list -l | tee out/out-03.txt

# test
ansible-playbook pb-test.yml -i iocage.yml | tee out/out-04.txt
