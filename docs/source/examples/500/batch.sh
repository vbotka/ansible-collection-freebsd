#!/usr/bin/bash
. ../defaults/batch
ansible-playbook pb-iocage-clone.yml -i iocage-hosts.ini | tee out/out-01.txt
ansible-playbook pb-syslog-server.yml -i hosts | tee out/out-02.txt
