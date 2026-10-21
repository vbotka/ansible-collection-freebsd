#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

ansible-playbook -i iocage.ini -t install -e install=true pb-test-01.yml | tee out/out-01.txt
ansible-playbook -i iocage.ini -t test pb-test-01.yml | tee out/out-02.txt
ansible-playbook -i iocage.ini pb-test-02.yml --check --diff | tee out/out-03.txt

touch .done
