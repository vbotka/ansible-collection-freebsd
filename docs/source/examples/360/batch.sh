#!/usr/bin/bash

. ../defaults/batch

# Destroy jails
VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini

# Configure loader.conf
ansible-playbook pb-loader.yml -i iocage.ini | tee out/out-01.txt

# Configure network
ansible-playbook pb-network.yml -i iocage.ini | tee out/out-02.txt
sleep 5

# Results
ssh admin@$iocage_04 ifconfig bridge0 | tee out/out-03.txt
sed -E -i "s/[0-9a-fA-F:]{17}/11:22:33:44:55:66/" out/out-03.txt
