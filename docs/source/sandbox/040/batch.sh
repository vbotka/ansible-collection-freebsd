#!/usr/bin/bash

ansible-playbook -i hosts pb.yml | tee out/out-01.txt
