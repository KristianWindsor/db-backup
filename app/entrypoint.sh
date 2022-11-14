#!/bin/bash

# exit on error
set -e

# check parameters
source ./check_parameters.sh

# create backup
if [[ $ACTION == "backup" ]]; then
    source ./backup.sh
elif [[ $ACTION == "restore" ]]; then
    source ./restore.sh
fi

# keep alive in debug mode
if [[ $DEBUG_MODE == "true" ]]; then
    while true; do sleep 10000; done
fi