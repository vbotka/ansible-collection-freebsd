#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# ansible-playbook -i localhost, pb-iocage-obsolete.yml
#

# Test
ansible-playbook -i hosts pb.yml | tee out/out-01.txt
