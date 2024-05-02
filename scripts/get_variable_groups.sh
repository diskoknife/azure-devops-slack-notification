#!/usr/bin/bash

set -e
set -o pipefail

if [ -z "$JSON_VARIABLES_GROUPS" ]; then
    echo "Please set the JSON_VARIABLES_GROUPS as file to which output will be written"
    echo "export JSON_VARIABLES_GROUPS="path/to/file.json""
    exit 1
fi

output=($JSON_VARIABLES_GROUPS)

variableGroups=$(az pipelines variable-group list --query '[].name')

echo "$variableGroups" > "$output"