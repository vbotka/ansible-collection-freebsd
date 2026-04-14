#!/usr/bin/bash

. ../defaults/batch

# Display inventory
ansible-inventory --list --yaml | tee out/out-01.txt

# Test the connection plugin vbotka.freebsd.jailexec
ansible-playbook -i jailexec.ini pb.yml | tee out/out-02.txt
