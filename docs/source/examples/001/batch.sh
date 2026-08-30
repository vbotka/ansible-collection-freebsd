#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Debug
ansible-playbook pb-iocage.yml -i iocage.ini -l iocage_04 -t freebsd_iocage_debug -e freebsd_iocage_debug=true | tee out/out-01.txt

# Install iocage
ansible-playbook pb-iocage.yml -i iocage.ini -l iocage_04 -t freebsd_iocage_pkg -e freebsd_iocage_debug=true | tee out/out-02.txt
