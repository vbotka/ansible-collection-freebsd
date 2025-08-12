#!/usr/bin/bash

. ../defaults/batch

ansible-playbook pb.yml | tee out/out-01.txt

# ANSIBLE_DISPLAY_OK_HOSTS=false 
