#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Test
ansible-playbook -i iocage.ini -l iocage_06 -t freebsd_iocage_sanity pb-iocage.yml | tee out/out-01.txt

# Test quietly
ANSIBLE_DISPLAY_OK_HOSTS=false ANSIBLE_DISPLAY_SKIPPED_HOSTS=false ansible-playbook -i iocage.ini -l iocage_06 -t freebsd_iocage_sanity pb-iocage.yml | tee out/out-02.txt
