#!/bin/bash

output_file="dependencies.txt"

# Clear the output file if it exists
> "$output_file"

# Read the Package.swift file
while read -r line; do
  # Check if the line contains the dependency URL and version range
  if [[ $line =~ \.package\(url:[[:space:]]*\"(.*\.git)\",[[:space:]]*from:[[:space:]]*\"(.*)\"\) ]]; then
    url="${BASH_REMATCH[1]}"
    version_range="${BASH_REMATCH[2]}"

    # Extract the package name from the URL
    package_name=$(basename "$url" .git)

    # Check the latest version available
    latest_version=$(git ls-remote --tags "$url" | grep -Eo "refs/tags/[0-9.]+" | awk -F/ '{print $NF}' | sort -V | tail -n1)

    # Output the package name and latest version to the file
    echo "Package: $package_name" >> "$output_file"
    echo "Latest Version: $latest_version" >> "$output_file"
    echo >> "$output_file"
  fi
done <Package.swift

echo "Dependency information has been written to $output_file."
