#!/bin/bash -
#===============================================================================
# Get the IAM policy (who has access to what) for every project in the
# current GCP org and write it to output.txt.
#===============================================================================
set -uo pipefail

OUTFILE="output.txt"

if [ -e "$OUTFILE" ]; then
  read -r -p "$OUTFILE already exists. Overwrite? [y/N] " REPLY
  case "$REPLY" in
    [yY]|[yY][eE][sS]) ;;
    *) echo "Aborted."; exit 1 ;;
  esac
fi

echo "IAM LIST" > "$OUTFILE"

while read -r project; do
  echo "================ $project ==============" >> "$OUTFILE"
  gcloud projects get-iam-policy "$project" >> "$OUTFILE"
done < <(gcloud projects list --format="value(projectId)")

echo "Done. Results written to $OUTFILE"
