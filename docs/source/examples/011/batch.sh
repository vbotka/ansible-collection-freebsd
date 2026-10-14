#!/usr/bin/bash
61;8000;1c
# shellcheck disable=SC1091
. ../defaults/batch

# Display iocage_* vars
ansible-playbook pb-vars-all.yml -i iocage.yml -l test-613 | tee out/out-01.txt

touch .done
