#!/usr/bin/bash

. ../defaults/batch

ansible-playbook pb-iocage.yml -i iocage.ini -l iocage_04 -t freebsd_iocage_sanity | tee out/out-01.txt
ANSIBLE_DISPLAY_OK_HOSTS=false ANSIBLE_DISPLAY_SKIPPED_HOSTS=false ansible-playbook pb-iocage.yml -i iocage.ini -l iocage_04 -t freebsd_iocage_sanity | tee out/out-02.txt
