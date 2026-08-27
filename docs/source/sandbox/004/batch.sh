#!/usr/bin/bash

. ../defaults/batch

# Configure local pkg-repo
ansible-playbook -i iocage.ini pb-packages.yml | tee out/out-01.txt
