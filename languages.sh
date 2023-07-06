#!/bin/bash
gem install github-linguist
github-linguist >> languages.txt
# Read the text file and extract the languages used
while read -r line; do
  # Extract the language name
  if [[ $line =~ [[:space:]]+([[:alpha:]]+)$ ]]; then
    language="${BASH_REMATCH[1]}"
    
    # Output the language
    echo $language >> temp.txt
  fi
done < languages.txt
cat temp.txt > languages.txt
rm temp.txt
