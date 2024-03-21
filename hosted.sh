#!/bin/bash
# hosted.sh

CURRENT_VERSION="1.1"

# Function to display help information
show_help() {
  echo "Usage: ./hosted.sh [local-port] [remote-port] [subdomain] [mode]"
  echo "Commands:"
  echo "  update              Update this script from GitHub"
  echo "  [local-port] [remote-port] [subdomain(optional)] [mode: ssh/autossh(optional)]  Set up a reverse SSH tunnel with serveo.net"
  echo "  help                Display this help message"
}

# Function to check for updates
check_for_updates() {
    # Fetch the latest version number from the GitHub repository
    LATEST_VERSION=$(curl -s https://raw.githubusercontent.com/oyin25/serveo/main/version.txt)
    
    if [ "$LATEST_VERSION" != "$CURRENT_VERSION" ]; then
        echo -e "\e[31mUpdate available: Version $LATEST_VERSION is available. Run './hosted.sh update' to update.\e[0m"
    fi
}

# Handle different commands
case "$1" in
  update)
    cd "$(dirname "$0")" && git pull https://github.com/oyin25/serveo.git main
    echo "Script updated successfully!"
    ;;
  help)
    show_help
    ;;
  *)
    check_for_updates
    if [[ -n $1 ]] && [[ -n $2 ]]; then
      command="ssh"
      if [[ $4 == "autossh" ]]; then
        command="autossh -M 0"
      fi

      if [[ -n $3 ]]; then
        # If the subdomain is provided.
        $command -R $3:$1:localhost:$2 serveo.net
      else
        # If no subdomain is provided.
        $command -R $1:localhost:$2 serveo.net
      fi
    else
      echo "Error: Incorrect usage."
      show_help
    fi
    ;;
esac
