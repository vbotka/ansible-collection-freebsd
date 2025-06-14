#!/usr/bin/bash

. ../defaults/batch
tee_enable="${VBOTKA_FREEBSD_TEE_ENABLE:-true}"
jails_destroy="${VBOTKA_FREEBSD_JAILS_DESTROY:-true}"

my_tee () {
    if $tee_enable; then tee "$1"; fi
}

ssh admin@$iocage_02 iocage list -lt | my_tee out/out-01.txt
ssh admin@$iocage_03 iocage list -lt | my_tee out/out-02.txt
ansible-playbook pb-iocage-swarms-create.yml -i iocage-hosts.ini | my_tee out/out-03.txt
ssh admin@$iocage_02 iocage list -l | my_tee out/out-04.txt
ssh admin@$iocage_03 iocage list -l | my_tee out/out-05.txt
ansible-playbook pb-test-all.yml -i hosts | my_tee out/out-06.txt
ansible-playbook pb-test-db.yml -i hosts | my_tee out/out-07.txt

if $jails_destroy; then
    ansible-playbook pb-iocage-swarms-destroy.yml -i iocage-hosts.ini -i hosts | my_tee out/out-08.txt
fi
