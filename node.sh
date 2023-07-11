#!/bin/bash
    echo "------------------" >> version_updates.txt
    echo "Node (package.json) Dependency alert" >> version_updates.txt
    echo "------------------" >> version_updates.txt
# Read the JSON file
json=$(cat packages.json)

# Extract the "dependencies" field and save it to a new JSON file
echo "$json" | jq '{ dependencies }' > dependencies.json
truncate -s 0 version_updates.txt
json=$(cat dependencies.json | jq '.dependencies')
echo "$json" | jq -c 'to_entries[]' | while IFS= read -r element; do
    key=$(echo "$element" | jq -r '.key')
    value=$(echo "$element" | jq -r '.value')
    # echo "Key: $key, Value: $value"
    cur=$(npm show $key version)
    # echo $cur
    if [ "$cur" != "$value" ] && [ "^$cur" != "$value" ]; then
        echo "Update available for $key... Latest $cur available">>version_updates.txt
    fi
done

rm -f dependencies.json
    echo "------------------" >> version_updates.txt
