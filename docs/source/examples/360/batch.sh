#!/usr/bin/bash

. ../defaults/batch

ansible-playbook pb-loader.yml -i iocage.ini | tee out/out-01.txt
ansible-playbook pb-network.yml -i iocage.ini | tee out/out-02.txt
sleep 5

ssh admin@$iocage_03 ifconfig bridge0 | tee out/out-03.txt
sed -E -i "s/[0-9a-fA-F:]{17}/11:22:33:44:55:66/" out/out-03.txt

ssh admin@$iocage_04 ifconfig bridge0 | tee out/out-04.txt
sed -E -i "s/[0-9a-fA-F:]{17}/11:22:33:44:55:66/" out/out-04.txt
