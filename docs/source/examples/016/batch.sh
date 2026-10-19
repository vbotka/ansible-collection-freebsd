#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Graph
ansible-inventory -i hosts --graph | tee out/out-01.txt

# Jails
ssh admin@iocage_05 iocage list -l | tee out/out-02.txt
ssh admin@iocage_06 iocage list -l | tee out/out-03.txt

# Test
ansible-playbook -i hosts pb-test.yml | tee out/out-04.txt

# Destroy jails in batch.
if [ "${VBOTKA_FREEBSD_BATCH:-}" = "true" ]; then
    ssh admin@iocage_05 sudo iocage stop -f test-511
    ssh admin@iocage_05 sudo iocage stop -f test-512
    ssh admin@iocage_05 sudo iocage stop -f test-513
    ssh admin@iocage_05 sudo iocage destroy -f test-511
    ssh admin@iocage_05 sudo iocage destroy -f test-512
    ssh admin@iocage_05 sudo iocage destroy -f test-513
    ssh admin@iocage_05 sudo iocage destroy -f ansible-test
    ssh admin@iocage_06 sudo iocage stop -f test-611
    ssh admin@iocage_06 sudo iocage stop -f test-612
    ssh admin@iocage_06 sudo iocage stop -f test-613
    ssh admin@iocage_06 sudo iocage destroy -f test-611
    ssh admin@iocage_06 sudo iocage destroy -f test-612
    ssh admin@iocage_06 sudo iocage destroy -f test-613
    ssh admin@iocage_06 sudo iocage destroy -f ansible-test
fi

touch .done
