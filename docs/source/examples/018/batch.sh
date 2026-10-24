#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Destroy jails in batch.
if [ "${VBOTKA_FREEBSD_BATCH:-}" = "true" ]; then
    ansible-playbook -i iocage.ini -i hosts pb-iocage-destroy.yml
    ssh admin@iocage_05 sudo iocage destroy -f ansible-test
    ssh admin@iocage_06 sudo iocage destroy -f ansible-test
fi

# Create basejails.
ansible-playbook -i iocage.ini pb-iocage-base.yml | tee out/out-01.txt

# Create clones.
ansible-playbook -i iocage.ini pb-iocage-clone.yml | tee out/out-02.txt

# Graph.
ansible-inventory -i hosts --graph | tee out/out-03.txt

# Jails.
ssh admin@iocage_05 sudo iocage list -l | tee out/out-04.txt
ssh admin@iocage_06 sudo iocage list -l | tee out/out-05.txt

# Start.
ansible-playbook -i iocage.ini -i hosts pb-iocage-start.yml | tee out/out-06.txt

# Test.
ansible-playbook -i hosts pb-test.yml | tee out/out-07.txt

# Do not destroy jails in batch. (The jails are used in 019.)

touch .done
