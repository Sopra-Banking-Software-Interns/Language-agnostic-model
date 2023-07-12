#!/bin/bash
    echo "------------------" >> version_updates.txt
    echo "Python (requirements.txt) Dependenct alert" >> version_updates.txt
    echo "------------------" >> version_updates.txt
# Read the requirements.txt file and extract dependency names and versions
while read -r line; do
  # Ignore comment lines and empty lines
  if [[ $line =~ ^[^#].* ]]; then
    # Extract the dependency name and version
    dependency=$(echo "$line" | awk -F '==' '{print $1}')
    version=$(echo "$line" | awk -F '==' '{print $2}')
    latest_version=$(pip index versions "$dependency" | sed -n 's/Available versions: \([0-9.]*\).*/\1/p')
    
    # Output the dependency name and version
    #echo "Dependency: $dependency"
    #echo "Version: $version"
    #echo "Latest Version: $latest_version"
    #echo "------------------"
    if [[ $version != $latest_version ]]; then
      line=$(echo "Update available for $dependency from $version to $latest_version")
      echo $line >> version_updates.txt
    fi
  fi
done < requirements.txt
    echo "------------------" >> version_updates.txt