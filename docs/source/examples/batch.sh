#!/usr/bin/bash

shopt -s globstar

. defaults/batch

export VBOTKA_FREEBSD_BATCH=true

# VBOTKA_FREEBSD_COPY_ORIG=false
# VBOTKA_FREEBSD_DESTROY_JAILS=false
# VBOTKA_FREEBSD_DESTROY_TEMPLATES=false
# VBOTKA_FREEBSD_RUN_BATCH=false

copy_orig="${VBOTKA_FREEBSD_COPY_ORIG:-true}"
destroy_jails="${VBOTKA_FREEBSD_DESTROY_JAILS:-true}"
destroy_templates="${VBOTKA_FREEBSD_DESTROY_TEMPLATES:-true}"
run_batch="${VBOTKA_FREEBSD_RUN_BATCH:-true}"

echo copy_orig="$copy_orig"
echo destroy_jails="$destroy_jails"
echo destroy_templates="$destroy_templates"
echo run_batch="$run_batch"

# Copy orig files
if [[ $copy_orig == true ]]; then
    for i in **/*.orig; do
        d=$(dirname "$i")
	f=$(basename "$i")
	filename="${f%.*}"
        cp "$i" "${d}/${filename}"
    done
fi

# Destroy jails
if [[ $destroy_jails == true ]]; then
    ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini --flush-cache
fi

# Destroy templates
if [[ $destroy_templates == true ]]; then
    ssh admin@$iocage_01 "echo admin | sudo -S iocage destroy -f ansible_client"
    ssh admin@$iocage_02 sudo iocage destroy -f ansible_client
#   ssh admin@$iocage_03 sudo iocage destroy -f ansible_client
    ssh admin@$iocage_04 sudo iocage destroy -f ansible_client
fi

# Run all batch.sh
if [[ $run_batch == true ]]; then
    for batch in */batch.sh; do
        example=$(dirname "$batch")
	echo ""
        echo ">>> Start example $example - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
	if [ -f "${example}/.deny" ]; then
	    echo "Blacklisted. File .deny present."
	    continue
	elif [ -f "${example}/.done" ]; then
	    echo "Done. File .done present."
	    continue
	else
	    echo "Run."
	    (cd "$example" && ./batch.sh && touch .done)
	fi
    done
fi

# Sanitize files
if [[ $copy_orig == true ]]; then
    for i in **/*.san; do
        d=$(dirname "$i")
	f=$(basename "$i")
	filename="${f%.*}"
        cp "$i" "${d}/${filename}"
    done
fi
