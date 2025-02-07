#!/bin/bash

ORGANIZATION=$ORGANIZATION
REPO=$REPO
ACCESS_TOKEN=$ACCESS_TOKEN

RUNNER_SUFFIX=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)
RUNNER_NAME="dockerized-runner-${RUNNER_SUFFIX}"

echo "Configuring GitHub Actions Runner..."

REG_TOKEN=$(curl -sX POST -H "Authorization: token ${ACCESS_TOKEN}" \
    "https://api.github.com/repos/${ORGANIZATION}/${REPO}/actions/runners/registration-token" \
    | jq .token --raw-output)

cd /home/actions-runner

./config.sh \
    --unattended \
    --url "https://github.com/${ORGANIZATION}/${REPO}" \
    --token "${REG_TOKEN}" \
    --name "${RUNNER_NAME}" \
    --labels "self-hosted,Linux,Docker,Android" \
    --work "_work"

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token "${REG_TOKEN}"
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!