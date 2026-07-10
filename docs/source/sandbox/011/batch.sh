#!/usr/bin/bash

. ../defaults/batch

# Display iocage_* vars
ansible-playbook pb-vars-all.yml -i hosts | tee out/out-01.txt
