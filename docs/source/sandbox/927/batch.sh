#!/usr/bin/bash

ansible-playbook -i hosts pb-test-to-ucl.yml | tee out/out-01.txt
ansible-playbook -i hosts pb-test-from-ucl.yml | tee out/out-02.txt
