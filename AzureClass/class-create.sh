#!/bin/sh

if [ "$(az group exists -n ClassRG)" = "true" ]; then
        echo "Resource group ClassRG already exists"
else
        echo "Creating the resource group..."
        az group create -n ClassRG -l WestEurope
fi