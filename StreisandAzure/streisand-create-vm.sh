#!/bin/sh

# Setup options
if [ -z "$REGION" ]; then REGION=WestEurope; fi
if [ -z "$RG_NAME" ]; then RG_NAME=Streisand; fi
if [ -z "$NSG_NAME" ]; then NSG_NAME=StreisandNSG-$REGION; fi
if [ -z "$VM_NAME" ]; then VM_NAME=Streisand-$REGION; fi
if [ -z "$VM_SIZE"]; then VM_SIZE=Standard_B1s; fi
if [ -z "$VM_SSH_KEY"]; then VM_SSH_KEY=~/.ssh/id_rsa.pub; fi
if [ -z "$LOGFILE"]; then LOGFILE=streisand-create-vm-$(date -u +%Y%m%d-%H%M%S).log; fi

# Display configured options
echo "Configured options for a Streisand VM:"
echo "  Region:                 $REGION"
echo "  Resource Group:         $RG_NAME"
echo "  Network Security Group: $NSG_NAME"
echo "  VM Name:                $VM_NAME"
echo "  VM Size:                $VM_SIZE"
echo "  VM SSH Key:             $VM_SSH_KEY"
echo "  Log file name:          $LOGFILE"
echo

# Get confirmation from user
echo "This script will take about 10-15 minutes to complete."
read -p "Are you sure you want to continue? (y/N) " yesno
if [ "$yesno" != "y" ]; then exit; fi
echo

# Record start time
START_TIME=$(date +%s)

echo "Creating Azure Resource Group $RG_NAME..."
az group create -n $RG_NAME -l $REGION >> $LOGFILE

echo "Creating Network Security Group $NSG_NAME..."
az network nsg create -g $RG_NAME -n $NSG_NAME -l $REGION >> $LOGFILE

# Add firewall settings to NSG
echo "Adding firewall rules to $NSG_NAME:"
echo "  SSH...";                az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1000 --protocol Tcp --destination-port-ranges 22 -n SSH >> $LOGFILE
echo "  IPSec-IKE...";          az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1001 --protocol Udp --destination-port-ranges 500 -n IPSec-IKE >> $LOGFILE
echo "  IPSec-L2TP...";         az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1002 --protocol Udp --destination-port-ranges 1701 -n IPSec-L2TP >> $LOGFILE
echo "  IPSec-NATT...";         az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1003 --protocol Udp --destination-port-ranges 4500 -n IPSec-NATT >> $LOGFILE
echo "  HTTPS...";              az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1004 --protocol Tcp --destination-port-ranges 443 -n HTTPS >> $LOGFILE
echo "  HTTP...";               az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1005 --protocol Tcp --destination-port-ranges 80 -n HTTP >> $LOGFILE
echo "  OpenConnect-TCP...";    az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1006 --protocol Tcp --destination-port-ranges 4443 -n OpenConnect-TCP >> $LOGFILE
echo "  OpenConnect-UDP...";    az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1007 --protocol Udp --destination-port-ranges 4443 -n OpenConnect-UDP >> $LOGFILE
echo "  OpenVPN-TCP...";        az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1008 --protocol Tcp --destination-port-ranges 636 -n OpenVPN-TCP >> $LOGFILE
echo "  OpenVPN-UDP...";        az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1009 --protocol Udp --destination-port-ranges 8757 -n OpenVPN-UDP >> $LOGFILE
echo "  Stunnel...";            az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1010 --protocol Tcp --destination-port-ranges 993 -n Stunnel >> $LOGFILE
echo "  ShadowSocks-TCP...";    az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1011 --protocol Tcp --destination-port-ranges 8530 -n ShadowSocks-TCP >> $LOGFILE
echo "  ShadowSocks-UDP...";    az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1012 --protocol Udp --destination-port-ranges 8530 -n ShadowSocks-UDP >> $LOGFILE
echo "  Tor-bridge...";         az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1013 --protocol Tcp --destination-port-ranges 8443 -n Tor-bridge >> $LOGFILE
echo "  Tor-obfs4...";          az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1014 --protocol Tcp --destination-port-ranges 9443 -n Tor-obfs4 >> $LOGFILE
echo "  WireGuard...";          az network nsg rule create -g $RG_NAME --nsg-name $NSG_NAME --priority 1015 --protocol Udp --destination-port-ranges 51820 -n WireGuard >> $LOGFILE

# Create VM
echo "Creating VM..."
az vm create -n $VM_NAME -g $RG_NAME --image UbuntuLTS --size $VM_SIZE --nsg $NSG_NAME -l $REGION --ssh-key-value $VM_SSH_KEY >> $LOGFILE

# Migrate to standard tier (cheaper)
echo "Migrating disk to cheaper Standard tier:"
echo "  Getting VM ID...";              VM_ID=$(az vm show -g $RG_NAME -n $VM_NAME --query id -o tsv)
echo "  Getting OS disk name...";       VM_OSDISK_NAME=$(az vm show -g $RG_NAME -n $VM_NAME --query storageProfile.osDisk.name -o tsv)
echo "  Deallocating current VM...";    az vm deallocate --ids $VM_ID >> $LOGFILE
echo "  Updating disk...";              az disk update --sku Standard_LRS --name $VM_OSDISK_NAME --resource-group $RG_NAME >> $LOGFILE
echo "  Starting VM...";                az vm start --ids $VM_ID >> $LOGFILE
echo

# Show available VMS
echo "Done, the following VMs are available in the $RG_NAME resource group:"
az vm list -g $RG_NAME -d --query "sort_by([].{Name:name,IP:publicIps,Location:location,Size:hardwareProfile.vmSize,Provisioning:provisioningState,State:powerState},&Name)" -o table
echo 

# Display time taken
END_TIME=$(date +%s)
DELTA=$(expr $END_TIME - $START_TIME)
echo "It took $(expr $DELTA / 60) min, $(expr $DELTA % 60) sec."
echo "Time elapsed: $(expr $DELTA / 60) min, $(expr $DELTA % 60) sec" >> $LOGFILE
echo "Log file is available: $LOGFILE"
