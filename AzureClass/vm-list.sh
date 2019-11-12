#!/bin/sh

echo "Listing VMs..."
az vm list -g ClassRG -d --query "sort_by([].{Name:name,IP:publicIps,Location:location,Size:hardwareProfile.vmSize,Provisioning:provisioningState,State:powerState},&Name)" -o table