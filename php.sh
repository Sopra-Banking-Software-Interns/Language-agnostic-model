#!/bin/bash 
# Add this line to create the file


    echo "------------------" >> version_updates.txt
    echo "PHP (composer.json) Dependency alert" >> version_updates.txt
    echo "------------------" >> version_updates.txt
jq '.require' composer.json > depe.json
# Read the dependencies.json file
dependencies=$(cat depe.json )
# Create an array to store the latest versions
declare -A latest_versions
# Loop through each dependency and check the latest version
while IFS=':' read -r dependency version; do
    # Remove leading/trailing whitespace and quotes from the dependency and version
    dependency=$(echo "$dependency" | tr -d '[:space:]"')
    version=$(echo "$version" | tr -d '[:space:]"')

 

    # Use cargo search command to check the latest version
    latest_version=$(composer show -a $dependency | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)

    # Store the latest version in the array
    latest_versions["$dependency"]=$latest_version
echo 
 

    # Compare the version from dependencies.json with the latest version
    if [[ "$version" < "$latest_version" ]]; then
        echo "Update available for $dependency = $latest_version" >> latest_versions.txt
        echo "$latest_version"
    fi
done <<< "$dependencies"

echo "$(cat latest_versions.txt)" >> version_updates.txt
rm latest_versions.txt
rm depe.json
echo 
echo 
echo "Reading File"
echo 
echo 
while read line; do
    echo $line
done < version_updates.txt
