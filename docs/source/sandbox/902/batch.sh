#!/usr/bin/bash

. ../defaults/batch

# Display iocage_* vars
ansible-playbook -i iocage.yml pb-vars-iocage.yml
