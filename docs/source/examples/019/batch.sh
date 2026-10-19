#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Graph.
ansible-inventory -i hosts --graph | tee out/out-01.txt

# Jails.
ssh admin@iocage_05 sudo iocage list -l | tee out/out-02.txt
ssh admin@iocage_06 sudo iocage list -l | tee out/out-03.txt

# Test.
ansible-playbook -i hosts pb-test.yml | tee out/out-04.txt
ansible-playbook -i hosts pb-test-region.yml | tee out/out-05.txt

# Destroy jails in batch.
if [ "${VBOTKA_FREEBSD_BATCH:-}" = "true" ]; then
    (cd ../018 && ansible-playbook -i iocage.ini -i hosts pb-iocage-destroy.yml)
    ssh admin@iocage_05 sudo iocage destroy -f ansible-test
    ssh admin@iocage_06 sudo iocage destroy -f ansible-test
fi

touch .done
