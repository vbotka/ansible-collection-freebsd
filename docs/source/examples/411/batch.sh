#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

ansible-playbook pb.yml | tee out/out-01.txt
