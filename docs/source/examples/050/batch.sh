#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Test the connection plugin vbotka.freebsd.jailexec
ansible-playbook -i hosts pb.yml | tee out/out-01.txt
