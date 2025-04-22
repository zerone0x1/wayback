#!/bin/bash

# Check if file is provided and exists
if [ -z "$1" ] || [ ! -f "$1" ]; then
    echo "Usage: bash $0 urls.txt"
    exit 1
fi

echo -e "\033[0;33mDetected new subdomain: \033[0;32m$subdomain\033[0m \033[0;33mwaiting for 5 seconds...\033[0m" 
# Variable to store the last subdomain
last_subdomain=""

# Read unique URLs, strip scheme + domain + port, ignore .js files
sort -u "$1" | while IFS= read -r url; do
    # Extract the subdomain and path
    subdomain=$(echo "$url" | sed -E 's|https?://([^/]+).*|\1|' | cut -d'.' -f1-2)  # Extract main subdomain (e.g., sub.domain.com)
    path=$(echo "$url" | sed -E 's|https?://[^/]+||')  # Strip scheme and domain

    # Skip if the path ends with .js
    if [[ "$path" == *.js ]]; then
        continue
    fi

    # If the subdomain has changed, wait for 5 seconds
    if [[ "$subdomain" != "$last_subdomain" && -n "$last_subdomain" ]]; then
        echo -e "\033[0;33mDetected new subdomain: \033[0;32m$subdomain\033[0m \033[0;33mwaiting for 5 seconds...\033[0m"  # Yellow for message, green for subdomain
        sleep 5
    fi

    # Output the path and update the last subdomain
    echo "$path"
    last_subdomain="$subdomain"
done
