#!/bin/bash

# Path to the packages.config file
#!/bin/bash

# Path to the packages.config file

#!/bin/bash
filePath="packages.config" 
startTag="<packages>"
endTag="</packages>"
isInPackagesSection=false

while IFS= read -r line
do
  line=$(echo "$line" | tr -d '\r') # Remove carriage return if present

  if [[ $line == *"$startTag"* ]]; then
    isInPackagesSection=true
    continue
  fi

  if [[ $line == *"$endTag"* ]]; then
    isInPackagesSection=false
    break
  fi

  if [ "$isInPackagesSection" = true ]; then
    echo "$line" >> packages.txt
  fi
done < "$filePath"

PACKAGES_CONFIG="packages.txt"
# Read the packages.config file and extract package names and versions
packages=($(grep -oP '(?<=<package id=")[^"]+' $PACKAGES_CONFIG))
versions=($(grep -oP '(?<=version=")[^"]+' $PACKAGES_CONFIG))

# Loop through the packages and check for the latest versions
for ((i=0; i<${#packages[@]}; i++)); do
    package="${packages[i]}"
    version="${versions[i]}"

    # Get the latest version for the package
  #  latest_version=$(nuget list $package -AllVersions | awk '{print $2}' | tail -n 1)
 latest_version=$(curl -s "https://api.nuget.org/v3-flatcontainer/$package/index.json" | jq '.versions')
 latest_version=$(echo $latest_version | jq -r '.[-1]')
    # Compare the current version with the latest version
    if [[ "$version" != "$latest_version" ]]; then
        echo -n "Package: $package " >> version_updates.txt
        echo -n "Current version: $version " >> version_updates.txt
        echo -n "Latest version: $latest_version" >> version_updates.txt
        echo >> version_updates.txt
    fi
done
