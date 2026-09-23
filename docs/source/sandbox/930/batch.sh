#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Test filter vbotka.freebsd.clean_unsafe
ansible-playbook -i iocage.ini pb-01.yml | tee out/out-01.txt
