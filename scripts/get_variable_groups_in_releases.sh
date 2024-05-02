#!/usr/bin/bash

set -e
set -o pipefail


# check if JSON_OUTPUT_FILE env variable exists (next same variable will be used in python script)
if [ -z "$JSON_OUTPUT_FILE" ]; then
    echo "Please set the JSON_OUTPUT_FILE as file to which output will be written"
    echo "export JSON_OUTPUT_FILE="path/to/file.json""
    exit 1
fi

output=($JSON_OUTPUT_FILE)
# attach all of release id's to var
release_count=$(az pipelines release list --query "[].id")

# friendly reminder: bash has no types as you were expecting
release_ids=$(echo "$release_count" | grep -o '[0-9]\+')
> "$output"
for release_id in $release_ids
do
    # Do something with each release ID, for example, print it
    release_details=$(az pipelines release show \
    --id "$release_id" \
    --query '{
        release: name
        releaseVariableGroups: variableGroups[].name,
        stages: environments[].{
            stage: name,
            stageVariableGroup: variableGroups[].name
        }
    }' \
    --output json) \
    
    # Using jq simple filter for later using it in python parse module
    echo "$release_details" | jq -c '.' >> "$output"
done
