#!/usr/bin/bash

. ../defaults/batch
tee_enable="${VBOTKA_FREEBSD_TEE_ENABLE:-true}"
jails_destroy="${VBOTKA_FREEBSD_JAILS_DESTROY:-true}"

my_tee () {
    if $tee_enable; then tee "$1"; fi
}

# TODO: Destroy all jails and create: test_1, test_2, and test_3 at
# iocage_01, iocage_02, and iocage_03 respectively.

ssh admin@$iocage_01 iocage list -lt | my_tee out/out-01.txt
ssh admin@$iocage_02 iocage list -lt | my_tee out/out-02.txt
ssh admin@$iocage_03 iocage list -lt | my_tee out/out-03.txt
ansible-playbook -i hosts -i iocage-hosts.ini pb-iocage-project-create.yml -e debug=true | my_tee out/out-04.txt
ansible-playbook -i hosts pb-test-all.yml --flush-cache | my_tee out/out-05.txt
if $jails_destroy; then
    ansible-playbook -i hosts -i iocage-hosts.ini pb-iocage-project-destroy.yml -e debug=true | my_tee out/out-06.txt
    ansible-playbook -i hosts pb-test-all.yml --flush-cache | my_tee out/out-07.txt
fi
