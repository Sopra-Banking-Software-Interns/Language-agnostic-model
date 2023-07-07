#!/bin/bash

  echo "------------------" >> version_updates.txt
  echo "Java - Gradle (build.gradle) Dependenct alert" >> version_updates.txt
  echo "------------------" >> version_updates.txt


chmod +x ./gradlew
build_file="build.gradle"
plugin_line="id 'com.github.ben-manes.versions' version '0.39.0'"

# Check if the plugin line is already present in the build.gradle file
if ! grep -qF "$plugin_line" "$build_file"; then
  # Append the plugin line to the plugins section in the build.gradle file
  sed -i "/plugins\s{/a $plugin_line" "$build_file"
else
echo "Present"
fi
version=$(curl -s 'https://services.gradle.org/versions/current' | jq -r '.version')
./gradlew wrapper --gradle-version $version
./gradlew build

./gradlew dependencyUpdates -Drevision=release -DoutputFormatter=json > report.txt
report=$(cat report.txt)
echo -n "" > gradle_dependency.txt

capture=1

# Extract dependencies with later release versions
while IFS= read -r line; do
  if [[ $line == "The following dependencies have later release versions:" ]]; then
    capture=0
  elif [[ $line == "Gradle release-candidate updates:" ]]; then
    capture=1
  elif [[ $line == "     http://www.slf4j.org" ]]; then
    capture=1  
  elif [[ $line == "     https://openjdk.java.net/projects/openjfx/" ]]; then
    echo "sda"
  elif [[ $capture == 0 ]]; then
    echo "$line" >> gradle_dependency.txt
  fi
done <<< "$report"
rm report.txt
echo "$(cat gradle_dependency.txt)" >> version_updates.txt
rm gradle_dependency.txt
echo "------------------" >> version_updates.txt