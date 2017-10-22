#!/bin/sh

# Setup options
if [ -z "$REGION" ]; then REGION=WestEurope; fi
if [ -z "$RG_NAME" ]; then RG_NAME=Streisand; fi
if [ -z "$NSG_NAME" ]; then NSG_NAME=StreisandNSG_$REGION; fi
if [ -z "$VM_NAME" ]; then VM_NAME=Streisand_$REGION; fi
if [ -z "$VM_SIZE"]; then VM_SIZE=Standard_B1s; fi
if [ -z "$VM_SSH_KEY"]; then VM_SSH_KEY=~/.ssh/id_rsa.pub; fi

# Display configured options
echo "Configured options for a Streisand VM:"
echo "  Region:                 $REGION"
echo "  Resource Group:         $RG_NAME"
echo "  Network Security Group: $NSG_NAME"
echo "  VM Name:                $VM_NAME"
echo "  VM Size:                $VM_SIZE"
echo "  VM SSH Key:             $VM_SSH_KEY"

# Get confirmation from user
read -p "Are you sure you want to continue? (y/N) " yesno
if [ "$yesno" != "y" ]; then exit; fi
echo

echo "Creating Azure Resource Group $RG_NAME..."
az group create -n $RG_NAME -l $REGION
echo 

echo "Creating Network Security Group $NSG_NAME..."
az network nsg create -g $RG_NAME -n $NSG_NAME -l $REGION
echo

# Add firewall settings to NSG
echo "Adding firewall rules to $NSG_NAME..."
az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1000 --protocol Tcp --destination-port-ranges 22 -n SSH
az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1001 --protocol Udp --destination-port-ranges 500 -n IPSec_1
az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1002 --protocol Udp --destination-port-ranges 1701 -n IPSec_2
az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1003 --protocol Udp --destination-port-ranges 4500 -n IPSec_3
az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1004 --protocol Tcp --destination-port-ranges 443 -n HTTPS
az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1005 --protocol Tcp --destination-port-ranges 80 -n HTTP
az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1006 --protocol Tcp --destination-port-ranges 4443 -n OpenConnect_TCP
az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1007 --protocol Udp --destination-port-ranges 4443 -n OpenConnect_UDP
az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1008 --protocol Tcp --destination-port-ranges 636 -n OpenVPN_TCP
az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1009 --protocol Udp --destination-port-ranges 8757 -n OpenVPN_UDP
az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1010 --protocol Tcp --destination-port-ranges 993 -n Stunnel
az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1011 --protocol Tcp --destination-port-ranges 8530 -n ShadowSocks_TCP
az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1012 --protocol Udp --destination-port-ranges 8530 -n ShadowSocks_UDP
az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1013 --protocol Tcp --destination-port-ranges 8443 -n Tor_bridge
az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1014 --protocol Tcp --destination-port-ranges 9443 -n Tor_obfs4
az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1015 --protocol Udp --destination-port-ranges 51820 -n WireGuard
echo

# Create VM
echo "Creating VM..."
az vm create -n $VM_NAME -g $RG_NAME --image UbuntuLTS --size $VM_SIZE --nsg $NSG_NAME -l $REGION --ssh-key-value $VM_SSH_KEY
echo