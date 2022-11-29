#!/bin/bash

# Configuration
SUFFIX=$(openssl rand -hex 5)
RG_NAME=Test-$SUFFIX
NSG_NAME=Test-$SUFFIX-NSG
REGION=EastUS
SIZE=Standard_B2ms
IMAGE=win2022datacenter
VM_NAME=test$SUFFIX
USER_NAME=Developer
USER_PASS=Pw1-$(openssl rand -base64 18 | sed "s|[+/]|x|g")

# Display intentions and ask user if they want to proceed
echo "This will create the following Windows VM:"
echo "  Name:           $VM_NAME.$REGION.cloudapp.azure.com"
echo "  User:           $USER_NAME"
echo "  Password:       $USER_PASS"
echo "  Region:         $REGION"
echo "  Resource Group: $RG_NAME"
echo
read -p "Do you want to continue (y/n)? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

# Create resource group
echo "Creating the resource group..."
az group create -n $RG_NAME -l $REGION

# Create network security group
echo "Creating NSG in $REGION region..."
az network nsg create -g $RG_NAME -n $NSG_NAME -l $REGION

# Create firewall rules for RDP, HTTP, HTTPS and WMSvc
echo "Creating RDP rule..."
az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1000 \
                           --destination-port-ranges 3389 -n RDP
echo "Creating HTTP rule..."
az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1001 \
                           --destination-port-ranges 80 -n HTTP
echo "Creating HTTPS rule..."
az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1002 \
                           --destination-port-ranges 443 -n HTTPS
echo "Creating WMSvc rule..."
az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1003 \
                           --destination-port-ranges 8172 -n WMSvc

# Create virtual machine
echo "Creating virtual machine..."
az vm create -n $VM_NAME -g $RG_NAME \
             --admin-username $USER_NAME --admin-password $USER_PASS \
             --image $IMAGE --size $SIZE \
             --nsg $NSG_NAME -l $REGION \
             --public-ip-sku Standard \
             --public-ip-address-dns-name $VM_NAME

# Display results
echo "The following virtual machine has been created:"
echo "  Name:           $VM_NAME.$REGION.cloudapp.azure.com"
echo "  User:           $USER_NAME"
echo "  Password:       $USER_PASS"
echo "  Region:         $REGION"
echo "  Resource Group: $RG_NAME"
