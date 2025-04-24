#!/usr/bin/bash
. ../defaults/batch
VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage-hosts.ini
ssh admin@$iocage_01 sudo iocage destroy -f ansible_client
ssh admin@$iocage_02 sudo CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1 iocage destroy -f ansible_client
ssh admin@$iocage_03 sudo CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1 iocage destroy -f ansible_client
ansible-playbook vbotka.freebsd.pb_iocage_template.yml -i iocage-hosts.ini | tee out/out-01.txt
ssh admin@$iocage_01 sudo iocage list -lt | tee out/out-02.txt
ssh admin@$iocage_02 sudo CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1 iocage list -lt | tee out/out-03.txt
ssh admin@$iocage_03 sudo CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1 iocage list -lt | tee out/out-04.txt
