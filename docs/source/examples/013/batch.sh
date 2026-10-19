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

# Create basejails.
ansible-playbook -i iocage.ini pb-iocage-base.yml | tee out/out-01.txt

# Create clones.
ansible-playbook -i iocage.ini pb-iocage-clone.yml| tee out/out-02.txt

# Graph.
ansible-inventory -i hosts --graph | tee out/out-03.txt

# Display variables and groups.
ansible-playbook -i hosts pb-all.yml | tee out/out-04.txt

# Display iocage variables and groups.
ansible-playbook -i hosts pb-test.yml | tee out/out-05.txt

# Display jails running on vmm.
ansible-playbook -i hosts pb-test-vmm.yml | tee out/out-06.txt

touch .done
