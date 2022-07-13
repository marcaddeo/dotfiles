#!/usr/bin/env bash

main() {
  while true; do
    echo "Enabling torch..."
    curl -s -o /dev/null http://10.1.0.36/parameters\?torch=1
    sleep 5
    echo "Disabling torch..."
    curl -s -o /dev/null http://10.1.0.36/parameters\?torch=0
    sleep 120
  done
}

main "$@"
