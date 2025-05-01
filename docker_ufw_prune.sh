#!/bin/bash

# Define exceptions (container names or comments to preserve, separated by space)
source firewall.env

# Get all current Docker container names
running_containers=$(docker ps --format '{{.Names}}')

# Get UFW rules with comments and process them in reverse order
sudo ufw status numbered | grep '\[.*\]' | tac | while read -r line; do
    # Extract the rule number and comment
    rule_number=$(echo "$line" | sed -n 's/^\[[ ]*\([0-9]\{1,\}\)\].*/\1/p')
    comment=$(echo "$line" | sed -n 's/.*# \(.*\)/\1/p')

    # # Check if the comment is in the exceptions or matches a running container
    if [[ ! "$running_containers" =~ "$comment" && ! " ${EXCEPTIONS[*]} " =~ " $comment " ]]; then
        # Delete the rule if it's not in exceptions or related to a running container
        echo "sudo ufw delete $rule_number"
        yes | sudo ufw delete $rule_number
    fi
done

# Reload UFW to apply changes
sudo ufw reload
sudo ufw enable
sudo ufw status numbered