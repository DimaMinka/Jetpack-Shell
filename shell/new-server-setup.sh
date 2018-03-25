#!/bin/bash

source /home/vagrant/.bash_profile

# run apt-get noninteractive to minimize prompts hanging the script
export DEBIAN_FRONTEND=noninteractive

RED='\033[0;31m'
PURPLE='\033[0;35m'
BLUE='\033[1;34m'
GREEN='\033[1;32m'
NC='\033[0m'

if [ -z "$server_name" ]; then
	echo -e "${RED}Script requires server name be passed in as 1st argument${NC}"
	exit 1;
fi

if [ -z "$serverpilot_client_id" ]; then
	echo -e "${RED}Script requires ServerPilot client id be passed in as 2nd argument${NC}"
	exit 1;
fi

if [ -z "$serverpilot_api_key" ]; then
	echo -e "${RED}Script requires ServerPilot API key be passed in as 3rd argument${NC}"
	exit 1;
fi

apt-get update
apt-get -y install jq wget ca-certificates

echo -e "${PURPLE}Installing ServerPilot shell scripts${NC}"
curl -sSL http://cdk.mk/sps > \
	/usr/local/bin/serverpilot && chmod a+x /usr/local/bin/serverpilot

echo -e "${PURPLE}Registering new server${NC}"
server_creation_output=$(echo $server_name | xargs serverpilot -r servers create $1)

export SERVERID=$(echo "$server_creation_output" | jq -r '.data.id')
export SERVERAPIKEY=$(echo "$server_creation_output" | jq -r '.data.apikey')

printf '\nexport serverpilot_server_id="%s"' $SERVERID >> /home/vagrant/.bash_profile && source /home/vagrant/.bash_profile

echo "$server_creation_output"

if [ -z "$SERVERID" ] || [ "null" == "$SERVERID" ]; then
	echo -e "${RED}Error: Server ID is empty${NC}"
	exit 1;
fi

if [ -z "$SERVERAPIKEY" ] || [ "null" == "$SERVERAPIKEY" ]; then
	echo -e "${RED}Error:Server ID is empty${NC}"
	exit 1;
fi

serverpilot_user_output=$(echo $serverpilot_server_id | serverpilot find sysusers serverid=$serverpilot_server_id id)

printf '\nexport serverpilot_user_id="%s"' $serverpilot_user_output >> /home/vagrant/.bash_profile && source /home/vagrant/.bash_profile

echo -e "${BLUE}Use these values below if prompted${NC}"
echo -e "${BLUE}Server ID: $SERVERID${NC}"
echo -e "${BLUE}Sysuser ID: $serverpilot_user_output${NC}"
echo -e "${BLUE}Server API Key: $SERVERAPIKEY${NC}"


echo -e "${PURPLE}Download ServerPilot installer script${NC}"
wget -nv -O serverpilot-installer https://download.serverpilot.io/serverpilot-installer

bash serverpilot-installer --server-id="$SERVERID" --server-apikey="$SERVERAPIKEY"
rm serverpilot-installer

# Delete self
rm -- "$0"

echo ""
echo -e "${GREEN}Success:${NC} ServerPilot will now finish setting up your server. May take 1-2 minutes."
