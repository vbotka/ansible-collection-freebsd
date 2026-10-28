#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Graph.
ansible-inventory -i hosts --graph | tee out/out-01.txt

# Jails.
ssh admin@iocage_05 iocage list -l | tee out/out-02.txt
ssh admin@iocage_06 iocage list -l | tee out/out-03.txt

# Test.
ansible-playbook -i hosts pb-test.yml | tee out/out-04.txt

# Destroy jails in batch.
if [ "${VBOTKA_FREEBSD_BATCH:-}" = "true" ]; then
    cleanup_iocage_test_jails -i "5 6" -n "11 12 13" -a
fi

touch .done
