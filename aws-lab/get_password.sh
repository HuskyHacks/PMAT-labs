#!/bin/bash

set -e

# Check if jq is installed
if ! [ -x "$(command -v jq)" ]; then
    >&2 echo "Error: jq is not installed"
    exit 1
fi

# Parse instance ID from input JSON
instanceid=$(jq -r '.instanceid')

# Get username and password from instance output
user=$(aws ec2 get-console-output --instance-id $instanceid --output text --no-paginate | grep "the default application username is" | awk -F "'" '{print $2}')
password=$(aws ec2 get-console-output --instance-id $instanceid --output text --no-paginate | grep "Setting Bitnami application password to" | awk -F "'" '{print $2}')

# Check if username and password were successfully retrieved. Return a valid JSON object saying "unknown" if we can't retrieve the pass
# This is to allow TF to continue execution even in the event of a bash script error
if [ -z "$user" ] || [ -z "$password" ]; then
      cat <<EOF | jq -c
  {
    "user": "[unknown]",
    "password": "[unknown]"
  }
EOF
  
  else
  # Generate and print output JSON
  cat <<EOF | jq -c
  {
    "user": "$user",
    "password": "$password"
  }
EOF
fi

