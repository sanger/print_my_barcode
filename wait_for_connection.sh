#!/usr/bin/env bash

#
# This script waits TIMEOUT seconds for connection to HOST:PORT
# to be stablished and exit with 0 if success or 1 if error
set -o pipefail
set -o nounset

HOST=$1
PORT=$2
TIMEOUT=$3

TIMEOUT_END=$(($(date +%s) + TIMEOUT))
result=1
while [ $result -ne 0 ]; do
  echo "Waiting for connection to ${HOST}:${PORT}..."
  wget --spider "${HOST}:${PORT}"
  result=$?
  if [ $result -eq 0 ]; then
    echo "Connected to ${HOST}:${PORT}."
    exit 0
  else
    if [ $(date +%s) -ge $TIMEOUT_END ]; then
      echo "Operation timed out" >&2
      exit 1
    fi
    sleep 1
  fi
done
