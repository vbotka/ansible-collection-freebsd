#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Jails.
ssh admin@iocage_05 sudo iocage list -l | tee out/out-01.txt
ssh admin@iocage_06 sudo iocage list -l | tee out/out-02.txt

# Debug versions.
ansible-playbook -i iocage.ini -t freebsd_iocage_debug -e freebsd_iocage_debug=true pb-iocage.yml | grep version | tee out/out-03.txt

# Create custom fact scripts.
ansible-playbook -i iocage.ini -t freebsd_iocage_facts -e freebsd_iocage_facts=true pb-iocage.yml | tee out/out-04.txt

# Display custom fact script.
ssh admin@iocage_05 cat /etc/ansible/facts.d/iocage.fact | tee out/out-05.txt

# Test.
ansible-playbook -i iocage.ini -l iocage_05 pb-test.yml | tee out/out-06.txt

# Destroy jails in batch. (The jails are created in 020).
if [ "${VBOTKA_FREEBSD_BATCH:-}" = "true" ]; then
    (cd ../020 && ansible-playbook -i hosts -i iocage.ini pb-iocage-swarms-destroy.yml)
fi

touch .done
