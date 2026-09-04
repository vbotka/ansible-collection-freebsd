#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Create templates
ansible-playbook -i localhost, pb.yml | tee out/out-01.txt
