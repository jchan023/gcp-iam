# gcp-iam

Small scripts for auditing Google Cloud IAM and API key hygiene across every
project in an org. Mostly loops, if we're being honest.

## What's here

| Script | What it does |
| --- | --- |
| [`gcloud_unreskeys.sh`](gcloud_unreskeys.sh) | Loops through every project and flags API keys that have **no restrictions** (no API restriction, no application restriction). Unrestricted keys are one of the most common ways GCP credentials get abused after a leak. |
| [`project_access.sh`](project_access.sh) | Loops through every project and dumps the IAM policy (who has what role, on what) to `output.txt` for offline review. |

## Prerequisites

- [`gcloud` CLI](https://cloud.google.com/sdk/docs/install), authenticated (`gcloud auth login`)
- An identity with at least:
  - `resourcemanager.projects.list` at the org/folder level, to enumerate projects
  - `serviceusage.apiKeys.list` on each project, for `gcloud_unreskeys.sh`
  - `resourcemanager.projects.getIamPolicy` on each project, for `project_access.sh`
- Bash

## Usage

```bash
# Find API keys with no restrictions across every project you can see
./gcloud_unreskeys.sh

# Dump IAM policies for every project you can see into output.txt
./project_access.sh
```

Both scripts operate on whatever projects `gcloud projects list` returns for
the currently active account/config, so double-check `gcloud config list`
before running against anything sensitive.

## Notes

- Neither script modifies anything — they're read-only/audit scripts.
- `output.txt` is git-ignored; it will contain sensitive IAM data, so don't
  commit it or share it outside your org.
