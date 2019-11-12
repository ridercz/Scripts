#!/bin/sh

if [ "$(az group exists -n ClassRG)" = "true" ]; then
        echo "Deleting the ClassRG resource group in background..."
        az group delete -n ClassRG --yes --no-wait
else
        echo "Resource group ClassRG was already deleted"
fi
