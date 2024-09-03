#!/usr/bin/env bash

#
# This script waits TIMEOUT seconds for connection to cups
# to be established and exit with 0 if success or 1 if error
set -o pipefail
set -o nounset

TIMEOUT=$1

TIMEOUT_END=$(($(date +%s) + TIMEOUT))
result=1
while [ $result -ne 1 ]; do
  echo "Waiting for connection to cups..."
  result="`lpstat -r | grep 'scheduler is running' | wc -l`"
  if [ $result -eq 1 ]; then
    echo "Connected to cups"
    exit 0
  else
    if [ $(date +%s) -ge $TIMEOUT_END ]; then
      echo "Operation timed out" >&2
      exit 1
    fi
    sleep 1
  fi
done
