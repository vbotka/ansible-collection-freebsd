#!/usr/bin/bash

. ../defaults/batch

# destroy
VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini --flush-cache
echo admin | ssh admin@$iocage_01 sudo -S iocage destroy -f ansible_client
ssh admin@$iocage_02 sudo iocage destroy -f ansible_client
ssh admin@$iocage_04 sudo iocage destroy -f ansible_client

# create templates
(cd ../202 && ansible-playbook pb-iocage-template.yml -i iocage.ini --flush-cache)
echo admin | ssh admin@$iocage_01 sudo -S iocage create -n test_1 -r 13.5-RELEASE

# create test jails
ssh admin@$iocage_02 sudo iocage create -n test_2 -r 14.2-RELEASE
ssh admin@$iocage_04 sudo iocage create -n test_4 -r 14.3-RELEASE

# status of templates
ssh admin@$iocage_01 iocage list -lt | tee out/out-01.txt
ssh admin@$iocage_02 iocage list -lt | tee out/out-02.txt
ssh admin@$iocage_04 iocage list -lt | tee out/out-03.txt

# create jails
ansible-playbook -i hosts -i iocage.ini pb-iocage-project-create.yml -e debug=true | tee out/out-04.txt

# test
ansible-playbook -i hosts pb-test-all.yml --flush-cache | tee out/out-05.txt

# ansible-playbook -i hosts -i iocage.ini pb-iocage-project-destroy.yml -e debug=true | tee out/out-06.txt
# ansible-playbook -i hosts pb-test-all.yml --flush-cache | tee out/out-07.txt
