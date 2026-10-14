#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

date +%H:%M:%S | tee out/out-01.txt
ANSIBLE_STDOUT_CALLBACK=community.general.timestamp ansible-playbook pb-vars-ip4.yml -i iocage.yml --flush-cache | tee out/out-01.txt

date +%H:%M:%S | tee out/out-02.txt
ANSIBLE_STDOUT_CALLBACK=community.general.timestamp ansible-playbook pb-vars-ip4.yml -i iocage.yml | tee out/out-02.txt

# cache_file=/var/tmp/inventory_cache/iocage_05_s1_vbotka.freebsd.iocage_ka06f2d
# ansible-playbook -e cache_file="${cache_file}" pb-cache-dump.yml | tee out/out-03.txt

touch .done
