#!/usr/bin/bash

. ../defaults/batch

# Test
ansible-playbook pb-vars-ip4.yml -i hosts | tee out/out-01.txt

# cat /var/tmp/inventory_cache/iocage_02_vbotka.freebsd.iocage_a5393s_8ea2a | tee out/out-02.txt
# cat /var/tmp/inventory_cache/iocage_04_vbotka.freebsd.iocage_a5393s_d0c35 | tee out/out-03.txt
