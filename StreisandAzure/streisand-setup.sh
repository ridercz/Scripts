#!/bin/sh

# Check if running as root
if ! [ $(id -u) = 0 ]; then
   echo "Not running as root. Please run 'sudo ./streisand-setup.sh'."
   exit 1
fi

# Record start time
START_TIME=$(date +%s)

# Update system
echo "Updating system..."
apt-get update
apt-get upgrade -y
apt-get install -y git python-paramiko python-pip python-pycurl python-dev build-essential
pip install --upgrade pip

# Instal Ansible prerequisites
echo "Installing Python libraries"
pip install ansible markupsafe

# Get Streisand
echo "Cloning Streisand..."
git clone https://github.com/jlund/streisand.git
cd streisand

# Display time taken
END_TIME=$(date +%s)
DELTA=$(expr $END_TIME - $START_TIME)
echo "It took $(expr $DELTA / 60) min, $(expr $DELTA % 60) sec."
echo

# Run Streisand setup
./streisand
