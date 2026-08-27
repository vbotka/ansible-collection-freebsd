#!/usr/bin/bash

. ../defaults/batch

# Display iocage properties
ansible-playbook pb-vars-properties.yml -i hosts | tee out/out-01.txt
