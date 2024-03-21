#!/bin/bash
# hosted.sh

CURRENT_VERSION="1.1"

# Function to display help information
show_help() {
  echo "Usage: ./hosted.sh [options] [remote-port] [local-port] [subdomain(optional)]"
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

# Parse options
while getopts ":pt" opt; do
  case ${opt} in
    p )
      ssh_command="autossh -M 0"
      ;;
    t )
      ssh_command="ssh"
      ;;
    \? )
      echo "Invalid option: $OPTARG" 1>&2
      show_help
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

# Validate if either -p or -t is provided
if [ -z "$ssh_command" ]; then
  echo "You must specify either -p for a permanent connection or -t for a temporary connection."
  show_help
  exit 1
fi

# Handle different commands
if [[ -n $1 ]] && [[ -n $2 ]]; then
  # Use command with or without subdomain based on user input
  if [[ -n $3 ]]; then
    # With subdomain if provided
    $ssh_command -R $3:$1:localhost:$2 serveo.net
  else
    # Without subdomain, just port forwarding
    $ssh_command -R $1:localhost:$2 serveo.net
  fi
else
  case "$1" in
    update)
      # Navigate to the script's directory and pull updates
      cd "$(dirname "$0")" && git pull https://github.com/oyin25/serveo.git main
      echo "Script updated successfully!"
      ;;
    help)
      show_help
      ;;
    *)
      echo "Error: Incorrect usage."
      show_help
      ;;
  esac
fi
