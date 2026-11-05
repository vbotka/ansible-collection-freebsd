#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# In batch, manage templates.
if [ "${VBOTKA_FREEBSD_BATCH:-}" = "true" ]; then
    # Destroy templates.
    ssh admin@iocage_05 sudo iocage destroy -f ansible-init
    ssh admin@iocage_06 sudo iocage destroy -f ansible-init
    # Create templates.
    ansible-playbook -i iocage.ini pb-iocage-template.yml | tee out/out-01.txt
fi

# Templates.
ssh admin@iocage_05 sudo iocage list -lt | tee out/out-02.txt
ssh admin@iocage_06 sudo iocage list -lt | tee out/out-03.txt

touch .done
