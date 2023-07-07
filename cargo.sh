#!/bin/bash
CARGO_TOML="./Cargo.toml"

  echo "------------------" >> version_updates.txt
  echo "Rust (cargo.toml) Dependenct alert" >> version_updates.txt
  echo "------------------" >> version_updates.txt

grep "^\[dependencies\]" "$CARGO_TOML" -A9999 | grep -E "^[a-zA-Z0-9_-]+\s*=" | sed -e 's/^[ \t]*//' -e 's/[ \t]*$//' | tr -d '"' | sed 's/=\s*/": "/' | awk -F ': "' '{print "    \"" $1 "\: \"" $2 "\","}' | sed '1s/^/  {"dependencies": {\n/' | sed '$s/,$/\n  }\n}/' > cargo_toml.json

# Read the dependencies.json file
dependencies=$(cat cargo_toml.json | jq '.dependencies')
echo -n "" > latest_versions.txt
# Create an array to store the latest versions
declare -A latest_versions

# Loop through each dependency and check the latest version
while IFS=':' read -r dependency version; do
    # Remove leading/trailing whitespace and quotes from the dependency and version
    dependency=$(echo "$dependency" | tr -d '[:space:]"')
    version=$(echo "$version" | tr -d '[:space:]"')

    # Use cargo search command to check the latest version
    latest_version=$(cargo search $dependency --limit 1 | grep -m 1 -oE '([0-9]+\.){2}[0-9]+' | awk "{print $1}")
    


    # Store the latest version in the array
    latest_versions["$dependency"]=$latest_version

    # Compare the version from dependencies.json with the latest version
    if [[ "$version" != "$latest_version" ]]; then
        echo "Update available for $dependency = $latest_version" >> latest_versions.txt
    fi
done <<< "$dependencies"

echo "$(cat latest_versions.txt)" >> version_updates.txt
rm latest_versions.txt
rm cargo_toml.json
echo "------------------" >> version_updates.txt