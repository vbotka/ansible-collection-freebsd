#!/usr/bin/bash

. ../defaults/batch

# TODO: Destroy all jails and create: test_1, test_2, and test_3 at
# iocage_01, iocage_02, and iocage_03 respectively.
VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini

ssh admin@$iocage_01 iocage list -lt | tee out/out-01.txt
ssh admin@$iocage_02 iocage list -lt | tee out/out-02.txt
ssh admin@$iocage_03 iocage list -lt | tee out/out-03.txt

ansible-playbook -i hosts -i iocage.ini pb-iocage-project-create.yml -e debug=true | tee out/out-04.txt
ansible-playbook -i hosts pb-test-all.yml --flush-cache | tee out/out-05.txt

# ansible-playbook -i hosts -i iocage.ini pb-iocage-project-destroy.yml -e debug=true | tee out/out-06.txt
# ansible-playbook -i hosts pb-test-all.yml --flush-cache | tee out/out-07.txt
