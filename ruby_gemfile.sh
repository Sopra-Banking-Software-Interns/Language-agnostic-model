#!/bin/bash
    echo "------------------" >> version_updates.txt
    echo "Ruby (Gemfile) Dependenct alert" >> version_updates.txt
    echo "------------------" >> version_updates.txt
# Read the Gemfile file and extract dependency names and versions
while read -r line; do
  # Ignore comment lines and empty lines
  if [[ $line =~ ^[^#].* ]]; then
    # Extract the dependency name and version
    if [[ $line =~ ^gem\ \'([^,]+)\' ]]; then
      dependency="${BASH_REMATCH[1]}"
      if [[ $line =~ ,[[:space:]]?[\'\"]([^\'\"]+)[\'\"] ]]; then
        version="${BASH_REMATCH[1]}"
        latest_version=$(gem search "^$dependency$" --remote --no-verbose | awk "/$dependency / {print $2}")
      else
        version=""
      fi
      
      # Output the dependency name and version
      #echo "Dependency: $dependency"
      #echo "Version: $version"
      #echo "Latest Version: $latest_version"
      #echo "------------------"
          if [[ $version != $latest_version ]]; then
      line=$(echo "Updates available for $dependency from $version to $latest_version")
      echo $line >> version_updates.txt
    fi
    fi
  fi
done < Gemfile
    echo "------------------" >> version_updates.txt