#!/usr/bin/bash

ansible-playbook pb.yml -i hosts | tee out/out-01.txt
