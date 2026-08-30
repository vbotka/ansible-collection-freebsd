#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Display iocage_* vars
ansible-playbook -i iocage.yml pb-vars-iocage.yml
