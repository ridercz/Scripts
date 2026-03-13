#!/bin/bash

usage() {
    cat <<EOF
Usage: $(basename "$0") [options]

Options:
  -s, --suffix <value>          Set suffix used by default resource names
  -g, --resource-group <name>   Set resource group name
  -n, --nsg-name <name>         Set network security group name
  -r, --region <region>         Set Azure region (default: EastUS)
  -S, --size <size>             Set VM size (default: Standard_B2ms)
  -i, --image <image>           Set VM image URN
  -v, --vm-name <name>          Set VM name
  -u, --user-name <name>        Set admin username
  -p, --user-pass <password>    Set admin password
  -y, --yes                     Skip confirmation prompt
  -h, --help                    Show this help message

Examples:
    $(basename "$0")
    $(basename "$0") --region WestUS3 --yes
    $(basename "$0") --resource-group DEV-demo --nsg-name DEV-demo-NSG --vm-name devdemo --yes
    $(basename "$0") --user-name AdminUser --user-pass 'StrongP@ssw0rd!' --size Standard_D2s_v5 --yes
EOF
}

# Configuration defaults
SUFFIX=$(openssl rand -hex 2)
RG_NAME=
NSG_NAME=
REGION=EastUS
SIZE=Standard_B2ms
IMAGE=MicrosoftWindowsServer:WindowsServer:2025-datacenter-g2:latest
VM_NAME=
USER_NAME=Developer
USER_PASS=Pw1-$(openssl rand -base64 18 | sed "s|[+/]|x|g")
AUTO_CONFIRM=false

# Parse command-line options
while [[ $# -gt 0 ]]
do
    case "$1" in
        -s|--suffix)
            if [[ $# -lt 2 ]]; then
                echo "Error: $1 requires a value."
                usage
                exit 1
            fi
            SUFFIX="$2"
            shift 2
            ;;
        -g|--resource-group)
            if [[ $# -lt 2 ]]; then
                echo "Error: $1 requires a value."
                usage
                exit 1
            fi
            RG_NAME="$2"
            shift 2
            ;;
        -n|--nsg-name)
            if [[ $# -lt 2 ]]; then
                echo "Error: $1 requires a value."
                usage
                exit 1
            fi
            NSG_NAME="$2"
            shift 2
            ;;
        -r|--region)
            if [[ $# -lt 2 ]]; then
                echo "Error: $1 requires a value."
                usage
                exit 1
            fi
            REGION="$2"
            shift 2
            ;;
        -S|--size)
            if [[ $# -lt 2 ]]; then
                echo "Error: $1 requires a value."
                usage
                exit 1
            fi
            SIZE="$2"
            shift 2
            ;;
        -i|--image)
            if [[ $# -lt 2 ]]; then
                echo "Error: $1 requires a value."
                usage
                exit 1
            fi
            IMAGE="$2"
            shift 2
            ;;
        -v|--vm-name)
            if [[ $# -lt 2 ]]; then
                echo "Error: $1 requires a value."
                usage
                exit 1
            fi
            VM_NAME="$2"
            shift 2
            ;;
        -u|--user-name)
            if [[ $# -lt 2 ]]; then
                echo "Error: $1 requires a value."
                usage
                exit 1
            fi
            USER_NAME="$2"
            shift 2
            ;;
        -p|--user-pass)
            if [[ $# -lt 2 ]]; then
                echo "Error: $1 requires a value."
                usage
                exit 1
            fi
            USER_PASS="$2"
            shift 2
            ;;
        -y|--yes)
            AUTO_CONFIRM=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Resolve suffix-based defaults when not explicitly set
RG_NAME=${RG_NAME:-DEV-$SUFFIX}
NSG_NAME=${NSG_NAME:-DEV-$SUFFIX-NSG}
VM_NAME=${VM_NAME:-dev$SUFFIX}

# Display intentions and ask user if they want to proceed
echo "This will create the following Windows VM:"
echo "  Name:           $VM_NAME.$REGION.cloudapp.azure.com"
echo "  User:           $USER_NAME"
echo "  Password:       $USER_PASS"
echo "  Region:         $REGION"
echo "  Resource Group: $RG_NAME"
echo
if [[ "$AUTO_CONFIRM" != true ]]; then
    read -p "Do you want to continue (y/n)? " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        exit 1
    fi
fi

# Create resource group
echo "Creating the resource group..."
az group create -n "$RG_NAME" -l "$REGION"

# Create network security group
echo "Creating NSG in $REGION region..."
az network nsg create -g "$RG_NAME" -n "$NSG_NAME" -l "$REGION"

# Create firewall rules for RDP, HTTP, HTTPS and WMSvc
echo "Creating RDP rule..."
az network nsg rule create -g "$RG_NAME" --nsg-name "$NSG_NAME" --priority 1000 \
                           --destination-port-ranges 3389 -n RDP
echo "Creating HTTP rule..."
az network nsg rule create -g "$RG_NAME" --nsg-name "$NSG_NAME" --priority 1001 \
                           --destination-port-ranges 80 -n HTTP
echo "Creating HTTPS rule..."
az network nsg rule create -g "$RG_NAME" --nsg-name "$NSG_NAME" --priority 1002 \
                           --destination-port-ranges 443 -n HTTPS
echo "Creating WMSvc rule..."
az network nsg rule create -g "$RG_NAME" --nsg-name "$NSG_NAME" --priority 1003 \
                           --destination-port-ranges 8172 -n WMSvc

# Create virtual machine
echo "Creating virtual machine..."
az vm create -n "$VM_NAME" -g "$RG_NAME" \
             --admin-username "$USER_NAME" --admin-password "$USER_PASS" \
             --image "$IMAGE" --size "$SIZE" \
             --nsg "$NSG_NAME" -l "$REGION" \
             --public-ip-sku Standard \
             --public-ip-address-dns-name "$VM_NAME"

# Display results
echo "The following virtual machine has been created:"
echo "  Name:           $VM_NAME.$REGION.cloudapp.azure.com"
echo "  User:           $USER_NAME"
echo "  Password:       $USER_PASS"
echo "  Region:         $REGION"
echo "  Resource Group: $RG_NAME"
