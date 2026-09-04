#!/usr/bin/bash

ansible-playbook -i localhost, pb-test-to-ucl.yml | tee out/out-01.txt
ansible-playbook -i localhost, pb-test-from-ucl.yml | tee out/out-02.txt
