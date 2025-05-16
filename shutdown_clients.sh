#!/bin/bash

# List of client IPs or hostnames
clients=(
    "192.168.1.101"
    "192.168.1.102"
    "192.168.1.103"
)

# Remote username
user="your_remote_user"

# Loop through each client and send shutdown command
for client in "${clients[@]}"; do
    echo "Shutting down $client..."
    ssh "$user@$client" "sudo shutdown -h now" &
done

wait
echo "All shutdown commands sent."
