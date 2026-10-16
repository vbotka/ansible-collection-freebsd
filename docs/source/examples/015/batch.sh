#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Test
ansible-playbook -i hosts pb-vars-ip4.yml | tee out/out-01.txt

# cache_file=/var/tmp/inventory_cache/iocage_05_s1_vbotka.freebsd.iocage_k9573e1
# ansible-playbook -e cache_file="${cache_file}" pb-cache-dump.yml | tee out/out-02.txt
# cache_file=/var/tmp/inventory_cache/iocage_06_s1_vbotka.freebsd.iocage_k8aa36d
# ansible-playbook -e cache_file="${cache_file}" pb-cache-dump.yml | tee out/out-03.txt

touch .done
