#!/bin/bash
jq '.require' composer.json > depe.json

# Read the dependencies.json file
dependencies=$(cat depe.json )
echo -n "" > latest_versions.txt
echo -n "" > version_updates.txt  # Add this line to create the file
    echo "------------------" >> version_updates.txt
    echo "Python (requirements.txt) Dependenct alert" >> version_updates.txt
    echo "------------------" >> version_updates.txt
# Create an array to store the latest versions
declare -A latest_versions

# Loop through each dependency and check the latest version
while IFS=':' read -r dependency version; do
    # Remove leading/trailing whitespace and quotes from the dependency and version
    dependency=$(echo "$dependency" | tr -d '[:space:]"')
    version=$(echo "$version" | tr -d '[:space:]"')
    echo $dependency - $version
    
    # Use cargo search command to check the latest version
    latest_version=$(composer show -a $dependency | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
    echo $latest_version
    
    # Store the latest version in the array
    latest_versions["$dependency"]=$latest_version

    # Compare the version from dependencies.json with the latest version
    if [[ "$version" < "$latest_version" ]]; then
        echo "Update available for $dependency = $latest_version" >> version_updates.txt
        echo "Update available for $dependency = $latest_version"
    fi
done <<< "$dependencies"
rm depe.json
    echo "------------------" >> version_updates.txt