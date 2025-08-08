#!/usr/bin/bash

. ../defaults/batch

# test
ansible-playbook pb-test.yml -i hosts | tee out/out-01.txt
