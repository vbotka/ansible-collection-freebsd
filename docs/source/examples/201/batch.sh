#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Get iocage datasets.
ssh admin@iocage_05 sudo iocage list -r  | tee out/out-01.txt
ssh admin@iocage_06 sudo iocage list -r  | tee out/out-02.txt
ssh admin@iocage_05 sudo iocage list -P  | tee out/out-03.txt
ssh admin@iocage_06 sudo iocage list -P  | tee out/out-04.txt
ssh admin@iocage_05 sudo iocage list -lt | tee out/out-05.txt
ssh admin@iocage_06 sudo iocage list -lt | tee out/out-06.txt
ssh admin@iocage_05 sudo iocage list -l  | tee out/out-07.txt
ssh admin@iocage_06 sudo iocage list -l  | tee out/out-08.txt

# Display iocage datasets.
ansible-playbook pb-iocage-display-datasets.yml -i iocage.ini | tee out/out-09.txt

# Destroy jails in batch. (The jails are created in 200.)
if [ "${VBOTKA_FREEBSD_BATCH:-}" = "true" ]; then
    cleanup_iocage_test_jails -i "5 6" -n "11 12 13"
fi

touch .done
