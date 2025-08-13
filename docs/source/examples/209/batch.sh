#!/usr/bin/bash

. ../defaults/batch

# create pkglist file
ansible-playbook pb.yml -i iocage.ini | tee out/out-01.txt
