#!/usr/bin/env bash

set -euo pipefail
shopt -s globstar nullglob

# shellcheck disable=SC1091
if [[ -f defaults/batch ]]; then
    . defaults/batch
fi

# Allow environment variables to override defaults
: "${VBOTKA_FREEBSD_BATCH:=true}"
: "${VBOTKA_FREEBSD_COPY_ORIG:=false}"
: "${VBOTKA_FREEBSD_DESTROY_JAILS:=false}"
: "${VBOTKA_FREEBSD_DESTROY_TEMPLATES:=false}"

copy_orig="$VBOTKA_FREEBSD_COPY_ORIG"
destroy_jails="$VBOTKA_FREEBSD_DESTROY_JAILS"
destroy_templates="$VBOTKA_FREEBSD_DESTROY_TEMPLATES"
run_batch="$VBOTKA_FREEBSD_BATCH"

printf 'copy_orig=%s\n' "$copy_orig"
printf 'destroy_jails=%s\n' "$destroy_jails"
printf 'destroy_templates=%s\n' "$destroy_templates"
printf 'run_batch=%s\n' "$run_batch"

read -r -n 1 -p "Running all examples. Continue? [y/N]: " response
echo ""

if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

echo "Running all examples."

# Copy orig files
if [[ "$copy_orig" == true ]]; then
    for i in **/*.orig; do
        [[ -f "$i" ]] || continue
        # Strip .orig extension directly
        cp "$i" "${i%.orig}"
    done
fi

# Destroy jails
if [[ "$destroy_jails" == true ]]; then
    ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini --flush-cache
fi

# Destroy templates
if [[ "$destroy_templates" == true ]]; then
    ssh admin@iocage_05 sudo iocage destroy -f ansible_client
fi

# Run all batch.sh scripts
echo ">>> "
for batch in */batch.sh; do
    [[ -f "$batch" ]] || continue
    example="${batch%/*}"
    printf '>>> %s' "$example"

    if [[ -f "${example}/.deny" ]]; then
        echo " -"
    elif [[ -f "${example}/.done" ]]; then
	echo " + done $(date -r "${example}/.done" '+%Y-%m-%d %H:%M')"
    elif [[ "$run_batch" == true ]]; then
        echo " exec - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
        (cd "$example" && ./batch.sh && touch .done)
    else
        echo " * ready"
    fi
done

# Sanitize files
if [[ "$copy_orig" == true ]]; then
    for i in **/*.san; do
        [[ -f "$i" ]] || continue
        # Strip .san extension directly
        cp "$i" "${i%.san}"
    done
fi
