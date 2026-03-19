#!/usr/bin/bash

. ../defaults/batch

# Display iocage_* vars
ansible-playbook pb-vars-iocage.yml | tee out/out-01.txt
