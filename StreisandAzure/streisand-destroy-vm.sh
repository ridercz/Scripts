#!/bin/sh

# Setup options
if [ -z "$RG_NAME" ]; then RG_NAME=Streisand; fi

# Get confirmation
echo "This script will delete the $RG_NAME resource group and will take about 5 minutes to complete."
read -p "Are you sure you want to continue? (y/N) " yesno
if [ "$yesno" != "y" ]; then exit; fi
echo

# Record start time
START_TIME=$(date +%s)

# Delete the RG
echo "Deleting resource group..."
az group delete -n $RG_NAME -y

END_TIME=$(date +%s)
DELTA=$(expr $END_TIME - $START_TIME)
echo "Done in  $(expr $DELTA / 60) min, $(expr $DELTA % 60) sec."
