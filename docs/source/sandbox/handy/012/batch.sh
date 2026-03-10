#!/usr/bin/bash

. ../defaults/batch

# Display iocage properties
ansible-playbook pb-vars-properties.yml -i iocage.yml | tee out/out-01.txt
