#!/usr/bin/bash

. ../defaults/batch

# Display inventory
ansible-inventory --list --yaml -i iocage.yml

# Test the connection plugin jailexec
ansible-playbook -i jailexec.ini pb-test1.yml
