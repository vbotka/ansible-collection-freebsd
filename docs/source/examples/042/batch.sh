#!/usr/bin/bash

ansible-playbook -i localhost, pb-test-ast.yml | tee out/out-01.txt
ansible-playbook -i localhost, pb-test-nginx.yml | tee out/out-02.txt
