#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Destroy jails. (baz, qux)
ssh admin@iocage_05 sudo iocage destroy -f baz
ssh admin@iocage_06 sudo iocage destroy -f qux

# Create jails.
ansible-playbook -i hosts -i iocage.ini vbotka.freebsd.pb_iocage_project_create_from_templates.yml | tee out/out-01.txt

# Graph.
ansible-inventory -i hosts --graph | tee out/out-02.txt

# Jails.
ssh admin@iocage_05 sudo iocage list -l | tee out/out-03.txt
ssh admin@iocage_06 sudo iocage list -l | tee out/out-04.txt

# Test. (if at=now set sleep 90)
sleep 5
ssh admin@iocage_05 sudo iocage exec baz "cat /tmp/ansible-hello-world.txt" | tee out/out-05.txt
ssh admin@iocage_06 sudo iocage exec qux "cat /tmp/ansible-hello-world.txt" | tee out/out-06.txt

# In batch, stop and destroy jails.
if [ "${VBOTKA_FREEBSD_BATCH:-}" = "true" ]; then
    ssh admin@iocage_05 sudo iocage stop baz
    ssh admin@iocage_06 sudo iocage stop qux
    ssh admin@iocage_05 sudo iocage destroy -f baz
    ssh admin@iocage_06 sudo iocage destroy -f qux
fi

touch done.
