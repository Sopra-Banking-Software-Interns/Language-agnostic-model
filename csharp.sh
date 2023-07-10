#!/bin/bash

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
    latest_version=$(nuget list $package -AllVersions | awk '{print $2}' | tail -n 1)

    # Compare the current version with the latest version
    if [[ "$version" != "$latest_version" ]]; then
        echo -n "Package: $package"
        echo -n "Current version: $version"
        echo -n "Latest version: $latest_version"
        echo
    fi
done
