#!/usr/bin/bash
. ../defaults/batch
VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage-hosts.ini
ssh admin@$iocage_01 sudo iocage destroy -f ansible_client
ssh admin@$iocage_02 sudo CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1 iocage destroy -f ansible_client
ansible-playbook pb-iocage-fetch-base-clone.yml -i iocage-hosts.ini -t debug -e debug=true | tee out/out-01.txt
ansible-playbook pb-iocage-fetch-base-clone.yml -i iocage-hosts.ini -t runner | tee out/out-02.txt
ssh admin@$iocage_01 sudo iocage list -l | tee out/out-03.txt
ssh admin@$iocage_02 sudo CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1 iocage list -l | tee out/out-04.txt
ansible-playbook pb-iocage-list.yml -i iocage-hosts.ini -e debug=true | tee out/out-05.txt
ansible-playbook pb-test-01.yml -i iocage-hosts.ini | tee out/out-06.txt
