#!/usr/bin/env bash
set -uo pipefail

# Collection root validation: ensure script is executed from the collection root
if [[ ! -f "galaxy.yml" ]] || [[ ! -d "plugins" ]]; then
  echo "Error: Run this script from the collection root directory containing 'galaxy.yml' and 'plugins/'." >&2
  exit 1
fi

EXTRA_ARGS=("${@:---local}")
FAILED_PLUGINS=()
TOTAL_COUNT=0
PASSED_COUNT=0

# Dynamically populate PLUGINS array using find
# -print0 and readarray -d '' safely handle any unexpected whitespace or special characters
readarray -d '' PLUGINS < <(find plugins -type f -name "*.py" -print0 | sort -z)

if [[ ${#PLUGINS[@]} -eq 0 ]]; then
  echo "[-] No Python plugins found under 'plugins/'."
  exit 0
fi

echo "=== Running sanity checks on ${#PLUGINS[@]} plugins ==="
echo "Options: ${EXTRA_ARGS[*]}"
echo "--------------------------------------------------------"

for plugin in "${PLUGINS[@]}"; do
  ((TOTAL_COUNT++))
  echo -n "[*] Testing: $plugin ... "

  START_TIME=$(date +%s)
  OUTPUT=$(ansible-test sanity "$plugin" "${EXTRA_ARGS[@]}" 2>&1)
  STATUS=$?
  DURATION=$(( $(date +%s) - START_TIME ))

  if [[ $STATUS -eq 0 ]]; then
    echo "PASSED (${DURATION}s)"
    ((PASSED_COUNT++))
  else
    echo "FAILED (${DURATION}s)"
    echo "--- Output for $plugin ---"
    echo "$OUTPUT"
    echo "--------------------------"
    FAILED_PLUGINS+=("$plugin")
  fi
done

echo ""
echo "==================== Summary ===================="
echo "Total tested : $TOTAL_COUNT"
echo "Passed       : $PASSED_COUNT"
echo "Failed       : ${#FAILED_PLUGINS[@]}"

if [[ ${#FAILED_PLUGINS[@]} -gt 0 ]]; then
  echo ""
  echo "Failed plugins:"
  for failed in "${FAILED_PLUGINS[@]}"; do
    echo " - $failed"
  done
  exit 1
fi

echo "All plugins passed sanity tests successfully."
exit 0
