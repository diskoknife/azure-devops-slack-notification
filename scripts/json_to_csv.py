import os
import json
import csv

json_var_file=os.getenv("JSON_VARIABLES_GROUPS")
devops_releases=os.getenv("JSON_OUTPUT_FILE")
csv_output_file=os.getenv("CSV_OUTPUT_FILE")


def generate_csv(release_file, csv_output_file, variable_group_file):
    """

    First, we parse data from bash-generated json line by line.
    loads() works with string, load() with objects.
    Next we iterate over dictionary first appending release to array next release stages to it and so on over every line
    Next we determine what variable groups are exist in our scope and where are they used

    """
    with open(release_file, 'r') as json_data:
        data = []
        for line in json_data:
            data.append(json.loads(line))
    releases_and_stages = []
    for item in data:
        release = item['release']
        stages = [stage['stage'] for stage in item['stages']]
        releases_and_stages.append(release)
        releases_and_stages.extend(stages)
    with open(variable_group_file) as var_json:
        variable_groups = json.load(var_json)

    #defining header row in csv data
    csv_data = [[""] + releases_and_stages]
    
    for group in variable_groups:
        row = [group]
        for item in data:
            if 'stages' in item:
                for stage in item['stages']:
                    row.append(group in stage.get("stageVariableGroup", []))
                    print(stage)
                    print(row)
            row.append(group in item.get("releaseVariableGroups", []))
        csv_data.append(row)


    with open(csv_output_file, 'w') as csv_out:
        writer = csv.writer(csv_out)
        writer.writerows(csv_data)

generate_csv(devops_releases, csv_output_file, json_var_file)

