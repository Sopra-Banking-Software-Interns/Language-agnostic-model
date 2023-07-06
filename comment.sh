#!/bin/bash
echo "Hey! We have found that this repository uses the following languages:" >> comment.txt
# Read the languages.txt file and store the languages in an array
languages=()
while IFS= read -r line; do
  languages+=("$line")
done < languages.txt
echo "${languages[@]}" >> comment.txt
echo "And according to our database, these files are required to run the project:" >> comment.txt
echo 
echo
#echo languages: "${languages[@]}"
# Read the dependency.txt file and check if each language is present
while IFS= read -r line; do
  # Extract the language name and requirement file
    language="$(echo "$line" | sed -E 's/^([[:alnum:]\+\#\.]+)\s+.*$/\1/')"
    #echo "Language: $language"
    # Check if the language is present in the languages array
    for lang in "${languages[@]}"; do
      if [[ "$language" == "$lang" ]]; then
      echo "$line" >> comment.txt
      fi
    done
done < dependency.txt
echo "------------------" >> comment.txt
echo "If you want us to keep track of these files for latest updates, close the issue with the filename in the comment." >> comment.txt

