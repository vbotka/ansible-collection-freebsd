#!/usr/bin/bash

. ../defaults/batch

# Install git. Configure and start git_daemon
ansible-playbook pb.yml -i iocage.ini | tee out/out-01.txt

# Get service status
ssh admin@iocage_05 service git_daemon status | tee out/out-02.txt
