#!/bin/bash
# hosted.sh

CURRENT_VERSION="1.1"

# Function to display help information
show_help() {
  echo "Usage: ./hosted.sh -p|-t [remote-port] [local-port] [subdomain(optional)]"
  echo "Options:"
  echo "  -p                         Use autossh for a permanent, resilient connection"
  echo "  -t                         Use ssh for a temporary connection"
  echo "Commands:"
  echo "  update                     Update this script from GitHub"
  echo "  help                       Display this help message"
}

# Function to check for updates
check_for_updates() {
    # Fetch the latest version number from the GitHub repository
    LATEST_VERSION=$(curl -s https://raw.githubusercontent.com/oyin25/serveo/main/version.txt)
    
    if [ "$LATEST_VERSION" != "$CURRENT_VERSION" ]; then
        echo -e "\e[31mUpdate available: Version $LATEST_VERSION is available. Run './hosted.sh update' to update.\e[0m"
    fi
}

ssh_command=""
option_passed=false

# Parse options
while getopts ":pt" opt; do
  case ${opt} in
    p )
      ssh_command="autossh -M 0"
      option_passed=true
      ;;
    t )
      ssh_command="ssh"
      option_passed=true
      ;;
    \? )
      echo "Invalid option: $OPTARG" 1>&2
      show_help
      exit 1
      ;;
  esac
done

# Remove the options from the arguments list
shift $((OPTIND -1))

# Validate if either -p or -t is provided
if [ "$option_passed" = false ]; then
  echo "You must specify either -p for a permanent connection or -t for a temporary connection."
  show_help
  exit 1
fi

# Handle different commands
if [[ $# -ge 2 ]]; then
  remote_port=$1
  local_port=$2
  subdomain=${3:-""}
  
  # Construct the remote forwarding part of the SSH command
  forwarding_spec="$remote_port:localhost:$local_port"
  if [[ -n $subdomain ]]; then
    # If subdomain is provided, prefix it to the forwarding specification
    forwarding_spec="$subdomain:$forwarding_spec"
  fi
  
  # Execute the SSH or autossh command
  $ssh_command -R $forwarding_spec serveo.net
else
  echo "Error: Incorrect usage."
  show_help
fi
