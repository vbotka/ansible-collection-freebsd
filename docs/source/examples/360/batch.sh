#!/usr/bin/bash

. ../defaults/batch

ansible-playbook pb-loader.yml -i iocage.ini | tee out/out-01.txt
ansible-playbook pb-network.yml -i iocage.ini | tee out/out-02.txt
