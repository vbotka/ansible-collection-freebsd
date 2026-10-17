#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Graph.
ansible-inventory -i hosts --graph | tee out/out-01.txt

# Jails.
ssh admin@iocage_05 sudo iocage list -l | tee out/out-02.txt
ssh admin@iocage_06 sudo iocage list -l | tee out/out-03.txt

# Test.
ansible-playbook -i hosts pb-test-project.yml | tee out/out-04.txt
ansible-playbook -i hosts pb-test-connection-vars.yml | tee out/out-05.txt
ansible-playbook -i hosts pb-test-connection.yml | tee out/out-06.txt

# Do not destroy jails in batch. (The jails are used in 030. Created in 020).
# if [ "${VBOTKA_FREEBSD_BATCH:-}" = "true" ]; then
#     (cd ../020 &&ansible-playbook -i iocage.ini -i hosts pb-iocage-swarms-destroy.yml)
# fi

touch .done
