#!/bin/bash

if [ -z "$REPO" ] || [ -z "$ACCESS_TOKEN" ]; then
    echo "Error: REPO and ACCESS_TOKEN environment variables must be set"
    exit 1
fi

# Fix Docker socket permissions
if [ -e /var/run/docker.sock ]; then
    sudo chmod 666 /var/run/docker.sock
fi

echo "Configuring GitHub Actions Runner..."

./config.sh --url $REPO --token $ACCESS_TOKEN
./run.sh