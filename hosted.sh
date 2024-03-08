#!/bin/bash
# hosted.sh

# Function to display help information
show_help() {
  echo "Usage: ./hosted.sh [command] [args]"
  echo "Commands:"
  echo "  update              Update this script from GitHub"
  echo "  [local-port] [remote-port] [subdomain(optional)]  Set up a reverse SSH tunnel with serveo.net"
  echo "  help                Display this help message"
}

# Handle different commands
case "$1" in
  update)
    # Navigate to the script's directory
    cd "$(dirname "$0")" && git pull https://github.com/oyin25/serveo.git main
    echo "Script updated successfully!"
    ;;
  help)
    show_help
    ;;
  *)
    if [[ -n $1 ]] && [[ -n $2 ]]; then
      # Check if the subdomain argument is provided
      if [[ -n $3 ]]; then
        # If the user provides a subdomain (third argument), use it
        ssh -R $3:$1:localhost:$2 serveo.net
      else
        # If no subdomain is provided, just use port forwarding
        ssh -R $1:localhost:$2 serveo.net
      fi
    else
      echo "Error: Incorrect usage."
      show_help
      echo "For more information, type: ./hosted.sh help"
    fi
    ;;
esac
