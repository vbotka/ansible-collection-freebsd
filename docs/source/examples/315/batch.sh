#!/usr/bin/bash
. ../defaults/batch
ansible-playbook pb.yml -i iocage-hosts.ini | tee out/out-01.txt
