#!/bin/bash

# Script to reset VPN on Unifi Dream Machine Pro
# Author: renato-yuzup
# Date: 2025-02-05

LOGGER_ID="unifi_vpn_reset"

# Function to log messages
log_message() {
    local log_message=$1
    logger -t $LOGGER_ID "$log_message"
}

# Function to restart VPN service
restart_vpn() {
    log_message "Restarting VPN service..."
    /usr/sbin/ipsec restart
    log_message "VPN service restarted."
}

# Function to retrieve the current external IP address
get_external_ip() {
    external_ip=$(curl -s ifconfig.me)
    echo $external_ip
}

# Function to replace IP addresses in .config files
replace_ip_in_configs() {
    local new_ip=$1
    local config_dir=$2
    log_message "Replacing IP addresses in .config files with $new_ip..."
    for file in "$config_dir"/*.config; do
        sed -i -E "s/left=[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/left=$new_ip/g" "$file"
    done
    log_message "IP addresses successfully updated in all config files."
}

# Function to read the IP address from the first .config file in a directory
get_ip_from_first_config() {
    local config_dir=$1
    local ip_address=$(grep -m 1 -oP 'left=\K[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' "$config_dir"/*.config)
    echo $ip_address
}

# Main
log_message "Retrieving external IP address..."
external_ip=$(get_external_ip)
log_message "External IP address retrieved: $external_ip"

config_dir="/etc/ipsec.d/tunnels"
stored_ip=$(get_ip_from_first_config $config_dir)
log_message "Stored IP address retrieved: $stored_ip"

if [ "$external_ip" != "$stored_ip" ]; then
    log_message "IP addresses differ. Updating config files..."
    replace_ip_in_configs $external_ip $config_dir
    log_message "Restarting VPN service after IP update..."
    restart_vpn
    log_message "VPN service restarted after IP update."
else
    log_message "IP addresses are the same. No update needed."
fi

log_message "VPN reset script completed successfully. Everything is good."
