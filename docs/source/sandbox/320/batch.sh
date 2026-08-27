#!/usr/bin/bash

. ../defaults/batch

# Status of jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-01.txt

# Display inventory
ansible-inventory -i hosts -i iocage.ini --graph --flush-cache | tee out/out-03.txt

# Update repos
ansible-playbook -i iocage.ini -e debug=true pb-pkg-update.yml | tee out/out-02.txt

# Debug
ansible-playbook -i hosts -l test_151 -t pkg_debug -e pkg_debug=true pb-test-01.yml | tee out/out-04.txt

# Install packages
ansible-playbook -i hosts -i iocage.ini pb-test-01.yml | tee out/out-05.txt

# Install packages
ansible-playbook -i hosts -l test_151 -i iocage.ini -e pkg_debug=true pb-test-01.yml | tee out/out-06.txt

# Audit installed packages
ansible-playbook -i hosts -t pkg_stat -e pkg_stat=true -e pkg_audit_enable=true -e pkg_debug=true pb-test-01.yml | tee out/out-07.txt

# Audit installed packages at iocage host
ansible-playbook -i iocage.ini -t pkg_stat -e pkg_stat=true -e pkg_audit_enable=true -e pkg_debug=true pb-test-02.yml | tee out/out-08.txt
