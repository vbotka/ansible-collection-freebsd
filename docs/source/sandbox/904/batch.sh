#!/usr/bin/bash

. ../defaults/batch

# Display inventory
ansible-inventory -i iocage.yml --list --yaml

# Test the connection plugin jailexec
ansible-playbook -i jailexec.ini pb-test1.yml
