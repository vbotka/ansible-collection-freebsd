#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

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

# Display vars.
ansible-playbook pb-iocage-fetch-base-clone.yml -i iocage.ini -t debug -e debug=true | tee out/out-01.txt

# Create jails.
ansible-playbook pb-iocage-fetch-base-clone.yml -i iocage.ini -t runner | tee out/out-02.txt

# Jails.
ssh admin@iocage_05 sudo iocage list -l | tee out/out-03.txt
ssh admin@iocage_06 sudo iocage list -l | tee out/out-04.txt

# Display iocage datasets.
ansible-playbook pb-iocage-list.yml -i iocage.ini -e debug=true | tee out/out-05.txt

# Test.
ansible-playbook pb-test.yml -i iocage.ini | tee out/out-06.txt

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
