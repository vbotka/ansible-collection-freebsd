#!/usr/bin/bash

ansible-playbook -i localhost, pb-dict-to-ast.yml | tee out/out-01.txt
ansible-playbook -i localhost, pb-ast-to-haproxy.yml | tee out/out-02.txt
