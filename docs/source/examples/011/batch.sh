#!/usr/bin/bash

. ../defaults/batch

ansible-playbook pb-vars-all.yml -i iocage.yml -l test_133 | tee out/out-01.txt
