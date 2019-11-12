#!/bin/sh

DEFAULT_REGION=EastUS
DEFAULT_SIZE=Standard_B2ms
USER_NAME=Developer
USER_PASS=pass.word123
RG_NAME=ClassRG

if [ -z "$1" ]; then
        echo "SYNTAX: $0 name [region] [size] [--no-wait]"
        echo "  Default region: $DEFAULT_REGION"
        echo "  Default size:   $DEFAULT_SIZE"
        exit
fi

VMNAME=$1

if [ -z "$2" ]; then
        REGION=$DEFAULT_REGION
else
        REGION=$2
fi

if [ -z "$3" ]; then
        SIZE=$DEFAULT_SIZE
else
        SIZE=$3
fi

NSG_NAME=WebNSG_$REGION

if [ "$(az group exists -n $RG_NAME)" = "false" ]; then
        echo "Creating the resource group..."
        az group create -n $RG_NAME -l $REGION
fi

if [ -z $(az network nsg show -g $RG_NAME --name $NSG_NAME --query "name") ]; then
        echo "Creating NSG in $REGION region..."
        az network nsg create -g $RG_NAME -n $NSG_NAME -l $REGION
        echo "Creating RDP rule..."
        az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1000 --destination-port-ranges 3389 -n RDP
        echo "Creating HTTP rule..."
        az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1001 --destination-port-ranges 80 -n HTTP
        echo "Creating HTTPS rule..."
        az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1002 --destination-port-ranges 443 -n HTTPS
        echo "Creating WMSvc rule..."
        az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1003 --destination-port-ranges 8172 -n WMSvc
fi

echo "Creating virtual machine:"
echo "  Name:               $VMNAME"
echo "  Region:             $REGION"
echo "  Size:               $SIZE"
echo "  Additional options: $4"
az vm create -n $VMNAME -g $RG_NAME --admin-username $USER_NAME --admin-password $USER_PASS --image win2016datacenter --size $SIZE --nsg $NSG_NAME -l $REGION $4
