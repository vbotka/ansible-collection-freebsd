#!/usr/bin/bash

ansible-playbook -i localhost, pb-test-to-haproxy.yml | tee out/out-01.txt
