#!/usr/bin/bash
. ../defaults/batch
ssh admin@$iocage_02 iocage list -lt | tee out/out-01.txt
ssh admin@$iocage_03 iocage list -lt | tee out/out-02.txt
ansible-playbook pb-iocage-swarms-create.yml -i iocage-hosts.ini | tee out/out-03.txt
ssh admin@$iocage_02 iocage list -l | tee out/out-04.txt
ssh admin@$iocage_03 iocage list -l | tee out/out-05.txt
ansible-playbook pb-test-all.yml -i hosts | tee out/out-06.txt
ansible-playbook pb-test-db.yml -i hosts | tee out/out-07.txt
ansible-playbook pb-iocage-swarms-destroy.yml -i iocage-hosts.ini -i hosts | tee out/out-08.txt
