#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Activate iocage
ansible-playbook -i iocage.ini -t freebsd_iocage_activate -e freebsd_iocage_activate=true -e freebsd_iocage_debug=true pb-iocage.yml | tee out/out-01.txt
