#!/bin/bash

# Get all running Docker containers' names and ports
sudo docker ps --format '{{.Names}} {{.Ports}}' | while read line; do
    # Extract the container name and port mapping
    container_name=$(echo $line | awk '{print $1}')
    ports=$(echo $line | awk '{$1=""; print $0}' | sed 's/^ *//;s/ *$//')  # Remove container name and trim spaces

    # Split port mappings by comma, even if there are spaces after commas
    IFS=',' read -ra ADDR <<< "$ports"
    for i in "${ADDR[@]}"; do
        # Trim any leading/trailing spaces from each port entry
        port_entry=$(echo $i | sed 's/^ *//;s/ *$//')

        # Check if the port entry has a host IP/port -> container port mapping
        if [[ "$port_entry" == *'->'* ]]; then
            # Extract the host port (before the `->`)
            host_port=$(echo $port_entry | grep -oP '(?<=:)\d+(?=->)')
            protocol=$(echo $port_entry | grep -oP '(?<=\/)\w+')
        else
            # Handle single port mappings like `4369/tcp` or `9100/tcp`
            host_port=$(echo $port_entry | grep -oP '^\d+')
            protocol=$(echo $port_entry | grep -oP '(?<=\/)\w+')
        fi

        # Ensure the host_port and protocol are valid before adding UFW rules
        if [[ -n $host_port && -n $protocol ]]; then
            echo "sudo ufw allow $host_port/$protocol comment $container_name"
            yes | sudo ufw allow "$host_port/$protocol" comment "$container_name"
        fi
    done
done

# Reload UFW to apply changes
sudo ufw reload
sudo ufw enable
sudo ufw status numbered