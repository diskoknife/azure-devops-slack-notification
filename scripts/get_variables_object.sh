#!/usr/bin/bash

set -e
set -o pipefail

output="variables.json"
# attach all of release id's to var
release_count=$(az pipelines release list --query "[].id")

# friendly reminder: bash has no types as you were expecting
release_ids=$(echo "$release_count" | grep -o '[0-9]\+')
echo "" > whooeta.json
for release_id in $release_ids
do
    # Do something with each release ID, for example, print it
    az pipelines release show \
    --id "$release_id" \
    --query '{
        releaseVariableGroups: variableGroups[].name,
        stages: environments[].{
            stage: name,
            stageVariableGroup: variableGroups[].name
        }
    }' \
    --output json \
    >> "$output"
done