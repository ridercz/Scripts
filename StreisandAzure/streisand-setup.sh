# Update system
apt-get update
apt-get upgrade -y
apt-get install -y git python-paramiko python-pip python-pycurl python-dev build-essential

# Instal Ansible prerequisites
pip install ansible markupsafe

# Get Streisand
git clone https://github.com/jlund/streisand.git
cd streisand

# Run Streisand setup
./streisand