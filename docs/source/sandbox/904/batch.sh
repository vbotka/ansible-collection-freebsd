#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Display inventory
ansible-inventory --list --yaml -i iocage.yml

# Test the connection plugin jailexec
ansible-playbook -i jailexec.ini pb-test1.yml
