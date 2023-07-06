#!/bin/bash
mvn clean install

# Run Maven command to display dependency updates and save the output to a file
mvn versions:display-dependency-updates -Dmaven.test.skip=true | grep -E '^\[INFO\] [^\s]+' > maven_dependency_updates.txt
grep -E '^\[INFO\]   ' maven_dependency_updates.txt > upd.txt
awk '{print $2, $3, $4}' upd.txt > extracted_lines.txt
sed -n '2,$p' extracted_lines.txt > maven_dependency_updates.txt
rm extracted_lines.txt
rm upd.txt
# Display the content of the generated file
echo "$(cat maven_dependency_updates.txt)" >> version_changes.txt
