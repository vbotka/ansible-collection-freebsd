#!/usr/bin/bash

ansible-playbook -i iocage.ini -l iocage_06 pb.yml | tee out/out-01.txt
ansible-playbook -i iocage.ini pb-project.yml | tee out/out-02.txt
