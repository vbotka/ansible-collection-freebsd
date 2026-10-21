#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Graph.
ansible-inventory -i hosts -i iocage.ini --graph | tee out/out-01.txt

# Jails.
ssh admin@iocage_05 sudo iocage list -l | tee out/out-02.txt
ssh admin@iocage_06 sudo iocage list -l | tee out/out-03.txt

# Update repos.
ansible-playbook -i iocage.ini -e debug=true pb-pkg-update.yml | tee out/out-04.txt

# Debug.
ansible-playbook -i hosts -l log_server_01 -t pkg_debug -e pkg_debug=true pb-test.yml | tee out/out-05.txt

# Install packages.
ansible-playbook -i hosts -i iocage.ini pb-test.yml | tee out/out-06.txt

# Audit installed packages in jails.
ansible-playbook -i hosts -l log_server_01 -t pkg_stat -e pkg_stat=true -e pkg_audit_enable=true -e pkg_debug=true pb-test.yml | tee out/out-07.txt

touch .done
