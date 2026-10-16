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

# Create jails
# ansible-playbook -i iocage.ini pb-iocage-fetch.yml
# ansible-playbook -i iocage.ini pb-iocage-base.yml
# ansible-playbook -i iocage.ini pb-iocage-clone.yml
ansible-playbook -i iocage.ini pb-iocage-fetch-base-clone-list.yml | tee out/out-01.txt

# Jails
ssh admin@iocage_05 sudo iocage list -l | tee out/out-02.txt
ssh admin@iocage_06 sudo iocage list -l | tee out/out-03.txt

# Test
ansible-playbook -i iocage.yml pb-test.yml | tee out/out-04.txt

touch .done
