#!/usr/bin/bash

ansible-playbook -i hosts pb-test-ast.yml | tee out/out-01.txt
ansible-playbook -i hosts pb-test-nginx.yml | tee out/out-02.txt
