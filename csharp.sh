#!/bin/bash
  echo "------------------" >> version_updates.txt
  echo "C# (packages.config) Dependenct alert" >> version_updates.txt
  echo "------------------" >> version_updates.txt
# Path to the packages.config file
PACKAGES_CONFIG="packages.config"
# Read the packages.config file and extract package names and versions
packages=($(grep -oP '(?<=<package id=")[^"]+' $PACKAGES_CONFIG))
versions=($(grep -oP '(?<=version=")[^"]+' $PACKAGES_CONFIG))

# Loop through the packages and check for the latest versions
for ((i=0; i<${#packages[@]}; i++)); do
    package="${packages[i]}"
    version="${versions[i]}"

    # Get the latest version for the package
  #  latest_version=$(nuget list $package -AllVersions | awk '{print $2}' | tail -n 1)
 latest_version=$(curl -s "https://api.nuget.org/v3-flatcontainer/$package/index.json" | jq '.versions[-1]')
echo "$latest_version" >> myfile.txt
    # Compare the current version with the latest version
    if [[ "$version" != "$latest_version" ]]; then
        echo -n "Package: $package " >> version_updates.txt
        echo -n "Current version: $version " >> version_updates.txt
        echo -n "Latest version: $latest_version" >> version_updates.txt
        echo >> version_updates.txt
    fi
done
echo "$(cat version_updates)"
echo "------------------" >> version_updates.txt
