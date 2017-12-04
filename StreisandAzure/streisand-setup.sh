# Record start time
START_TIME=$(date +%s)

# Update system
apt-get update
apt-get upgrade -y
apt-get install -y git python-paramiko python-pip python-pycurl python-dev build-essential

# Instal Ansible prerequisites
pip install ansible markupsafe

# Get Streisand
git clone https://github.com/jlund/streisand.git
cd streisand

# Display time taken
END_TIME=$(date +%s)
DELTA=$(expr $END_TIME - $START_TIME)
echo "It took $(expr $DELTA / 60) min, $(expr $DELTA % 60) sec."
echo

# Run Streisand setup
./streisand