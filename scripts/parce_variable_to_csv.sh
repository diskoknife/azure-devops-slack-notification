#!/usr/bin/bash

set -e
set -o pipefail

output="output.csv"
header_data=",variable-group,key,value,release-1,release-2,release-3"

# if file defined in output variable exist - overwrite file. If not -> create it
if [ ! -f "$output" ]; then
    touch "$output"
fi
echo "$header_data" > "$output"


# csv-making works really bad with standart JSON output, so instead we use raw out
# first open the outer braces
# then we point .name as name of variable group
# then we point to the variables array ignoring the isSecret option
# read with '-r' parameter to deny any backslashes of the output
az pipelines variable-group list | jq -r '.[] | "\(.name), \(.variables | to_entries[] | [.key, .value.value] | @csv)"' | while IFS= read -r csv_line; do
    # Append the CSV line to the output file
    echo "'',$csv_line" >> "$output"
done