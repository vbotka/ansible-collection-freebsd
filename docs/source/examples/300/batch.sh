#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Test.
ansible-playbook -i iocage.ini pb-test.yml | tee out/out-01.txt
