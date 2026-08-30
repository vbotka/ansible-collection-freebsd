#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

VBOTKA_FREEBSD_BATCH=true ansible-playbook -i iocage.ini vbotka.freebsd.pb_iocage_destroy_all_jails.yml
ssh admin@iocage_06 sudo iocage destroy -f ansible_client

ansible-playbook -i iocage.ini -t debug -e debug=true pb-iocage-fetch-base-clone.yml | tee out/out-01.txt
ansible-playbook -i iocage.ini -t runner pb-iocage-fetch-base-clone.yml | tee out/out-02.txt

ssh admin@iocage_06 sudo iocage list -l | tee out/out-03.txt

ansible-playbook -i iocage.ini -e debug=true pb-iocage-list.yml | tee out/out-05.txt
ansible-playbook -i iocage.ini pb-test.yml | tee out/out-06.txt
