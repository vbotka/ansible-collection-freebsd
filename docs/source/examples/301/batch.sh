#!/usr/bin/bash
. ../defaults/batch
ansible-playbook pb-test-01.yml -i iocage-hosts.ini | tee out/out-01.txt
ansible-playbook pb-test-02.yml -i iocage-hosts.ini  --check --diff | tee out/out-02.txt
