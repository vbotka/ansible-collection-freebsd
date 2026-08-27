#!/usr/bin/bash

. ../defaults/batch

date +%H:%M:%S | tee out/out-01.txt
ANSIBLE_STDOUT_CALLBACK=community.general.timestamp ansible-playbook pb-vars-ip4.yml -i iocage.yml -l test_113 --flush-cache | tee -a out/out-01.txt

date +%H:%M:%S | tee out/out-02.txt
ANSIBLE_STDOUT_CALLBACK=community.general.timestamp ansible-playbook pb-vars-ip4.yml -i iocage.yml -l test_113 | tee -a out/out-02.txt

# cat /var/tmp/inventory_cache/iocage_vbotka.freebsd.iocage_a5393s_6a9dd | tee out/out-03.txt
