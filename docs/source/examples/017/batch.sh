#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# ansible-playbook -i localhost, pb-iocage-obsolete.yml

# Graph
ansible-inventory -i hosts --graph | tee out/out-01.txt

# Test
ansible-playbook -i hosts pb-test.yml | tee out/out-02.txt

touch .done
