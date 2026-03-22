#!/usr/bin/bash

. ../defaults/batch

# Display inventory
ansible-inventory -i iocage.yml --list --yaml
