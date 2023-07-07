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

REPO_URL="https://github.com/Tushar-2510/Language-agnostic-model"

# Issue title and body
ISSUE_TITLE="Dependency check for codespace"

mapfile -t lines < comment.txt

# Concatenate the lines into the issue body
ISSUE_BODY=""
for line in "${lines[@]}"; do
  ISSUE_BODY+="\n$line"
done

GITHUB_TOKEN="$token"

# Extract the owner and repository name from the URL
REPO_OWNER=$(echo "$REPO_URL" | awk -F/ '{print $(NF-1)}')
REPO_NAME=$(echo "$REPO_URL" | awk -F/ '{print $NF}' | sed 's/.git$//')

# Create the issue using the GitHub API
issue_response=$(curl -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  -d "{\"title\":\"$ISSUE_TITLE\",\"body\":\"$ISSUE_BODY\"}" \
  "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/issues")

# Check if the response is valid JSON
if ! jq -e . >/dev/null 2>&1 <<<"$issue_response"; then
  echo "Failed to create the issue"
  echo "API response:"
  echo "$issue_response"
  exit 1
fi

# Extract the issue number from the response
issue_number=$(echo "$issue_response" | jq -r '.number')

# Check if the issue number is null
if [[ "$issue_number" == "null" ]]; then
  echo "Failed to create the issue"
  echo "API response:"
  echo "$issue_response"
  exit 1
fi

# Display the created issue number
echo "New issue created: #$issue_number"
rm comment.txt
rm languages.txt

