#!/bin/bash
# hosted.sh

# Check if the first argument is 'update'
if [ "$1" = "update" ]; then
  # Navigate to the script's directory
  cd "$(dirname "$0")"
  
  # Pull the latest changes from your GitHub repository
  git pull https://github.com/oyin25/serveo.git main
  
  echo "Script updated successfully!"
  
  # Exit after updating
  exit 0
fi

# Original script functionality below...
if [[ -n $3 ]]; then
  # If the user provides a subdomain (third argument), use it
  ssh -R $3:$1:localhost:$2 serveo.net
else
  # If no subdomain is provided, omit the subdomain part
  ssh -R $1:localhost:$2 serveo.net
fi
