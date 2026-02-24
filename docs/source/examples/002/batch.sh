#!/usr/bin/bash

. ../defaults/batch

# Activate iocage
ansible-playbook pb-iocage.yml -i iocage.ini -l iocage_04 -t freebsd_iocage_activate -e freebsd_iocage_activate=true -e freebsd_iocage_debug=true | tee out/out-01.txt
