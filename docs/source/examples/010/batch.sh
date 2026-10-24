#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Destroy jails in batch.
if [ "${VBOTKA_FREEBSD_BATCH:-}" = "true" ]; then
    cleanup_iocage_test_jails "5 6" "11 12 13" true
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
