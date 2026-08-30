#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Debug
ansible-playbook -i iocage.ini -t freebsd_iocage_debug -e freebsd_iocage_debug=true pb-iocage.yml | tee out/out-01.txt

# Install iocage
ansible-playbook -i iocage.ini -t freebsd_iocage_pkg -e freebsd_iocage_debug=true pb-iocage.yml | tee out/out-02.txt
