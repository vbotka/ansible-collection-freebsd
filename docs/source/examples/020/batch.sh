#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Destroy jails in batch.
if [ "${VBOTKA_FREEBSD_BATCH:-}" = "true" ]; then
    ansible-playbook -i iocage.ini -i hosts -e debug=false -e dry_run=false pb-iocage-swarms-destroy.yml
fi

# Templates.
ssh admin@iocage_05 sudo iocage list -lt | tee out/out-01.txt
ssh admin@iocage_06 sudo iocage list -lt | tee out/out-02.txt

# Create jails.
ansible-playbook -i iocage.ini -e debug=true pb-iocage-swarms-create.yml | tee out/out-03.txt

# Graph.
ansible-inventory -i hosts --graph | tee out/out-04.txt 

# Jails.
ssh admin@iocage_05 sudo iocage list -l | tee out/out-05.txt
ssh admin@iocage_06 sudo iocage list -l | tee out/out-06.txt

# Test.
ansible-playbook -i hosts pb-test.yml | tee out/out-07.txt
# ansible-playbook -i hosts pb-test-properties.yml
# ansible-playbook -i hosts pb-test-hostuuid.yml
# ansible-playbook -i hosts pb-test-connection.yml

# Do not destroy jails in batch. (The jails are used in 021, 030.)

touch .done
