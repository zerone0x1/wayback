#!/bin/bash

# Check if file is provided and exists
if [ -z "$1" ] || [ ! -f "$1" ]; then
    echo "Usage: bash $0 urls.txt"
    exit 1
fi

# Initialize a variable to keep track of the last printed target domain
last_target=""

# Read unique URLs, extract paths, and group by domain
sort -u "$1" | while IFS= read -r url; do
    # Extract the domain (with scheme) and the path
    domain=$(echo "$url" | sed -E 's|https?://([^/]+).*|\1|')  # Get domain from URL
    path=$(echo "$url" | sed -E 's|https?://[^/]+||')  # Extract path, remove scheme and domain

    # Check if the domain has changed
    if [[ "$domain" != "$last_target" ]]; then
        # If the domain has changed, print the target in yellow
        echo -e "\033[1;33mTarget: https://$domain\033[0m"
        last_target="$domain"
    fi

    # If path is not empty, print it (skip empty paths)
    if [[ -n "$path" ]]; then
        echo "$path"
    fi
done
