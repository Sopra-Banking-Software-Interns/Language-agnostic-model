#!/bin/bash

TOKEN="$token"

echo "Here's the new comment that I found:"

# Extract the username and repository name from the GitHub URL
URL="https://github.com/Sopra-Banking-Software-Interns/Language-agnostic-model"
USERNAME=$(echo "$URL" | sed -n 's#https://github.com/\([^/]*\)/\([^/]*\).*#\1#p')
REPO=$(echo "$URL" | sed -n 's#https://github.com/\([^/]*\)/\([^/]*\).*#\2#p')

# GitHub API endpoint
API="https://api.github.com"

# Fetch all closed issues
closed_issues=$(curl -sSL -H "Authorization: token $TOKEN" "$API/repos/$USERNAME/$REPO/issues?state=closed&per_page=100")

# Check if closed_issues is empty
if [[ -z "$closed_issues" ]]; then
    echo "No closed issues found."
    exit 0
fi

# Find the latest closed issue
latest_closed_issue=$(echo "$closed_issues" | jq -r '[.[] | select(.comments > 0)] | sort_by(.updated_at) | last')

# Check if latest_closed_issue is empty
if [[ -z "$latest_closed_issue" ]]; then
    echo "No latest closed issue with comments found."
    exit 0
fi

# Fetch the comments of the latest closed issue
latest_issue_comments_url=$(echo "$latest_closed_issue" | jq -r '.comments_url')
latest_issue_comments=$(curl -sSL -H "Authorization: token $TOKEN" "$latest_issue_comments_url")

# Find the latest comment from the latest closed issue
latest_comment=$(echo "$latest_issue_comments" | jq -r '[.[] | {created_at: .created_at, body: .body}] | sort_by(.created_at) | last | .body')

# Check if latest_comment is empty
if [[ -z "$latest_comment" ]]; then
    echo "No latest comment found in the latest closed issue."
    exit 0
fi

# Check if the first line of latest_comment includes ~UPD tag
if [[ $latest_comment == *'~UPD'* ]]; then
    echo "Flag ~UPD found in the first line. Performing actions..."
    
    # Store subsequent lines in dependency_present.txt file
    echo "$latest_comment" | awk -v tag="~UPD" 'NR==1{if ($0 ~ tag) check=1; else {print "Flag ~UPD not found. Aborting..."; exit 1}} NR>1{if (check) print $0}' > dependency_present.txt
    echo "$(cat dependency_present.txt)"
    if [[ $? -eq 0 ]]; then
        echo "Lines after ~UPD tag in the latest comment have been written to dependency_present.txt file."
    else
        echo "Error occurred while writing the lines to dependency_present.txt file."
    fi
else
    echo "Flag ~UPD not found in the first line. Aborting..."
    exit 0
fi
