#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Create haproxy user, group, and login class.
ansible-playbook -i iocage.ini pb.yml | tee out/out-01.txt

touch .done
