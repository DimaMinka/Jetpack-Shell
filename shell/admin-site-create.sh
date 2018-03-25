#!/bin/bash

source /home/vagrant/.bash_profile

RED='\033[0;31m'
PURPLE='\033[0;35m'
BLUE='\033[1;34m'
GREEN='\033[1;32m'
NC='\033[0m'

echo -e "${GREEN}Serverpilot admin app provision${NC}"

echo -e "${RED}admin.test - domain to use for the site:${NC}"

result=$( serverpilot apps create "admin" "$serverpilot_user_id" "php7.2" '["admin.test"]')

echo $result

appId=$(serverpilot find apps serverid=$serverpilot_server_id,name="admin" id)
appInfo=$(serverpilot apps $appId)

echo -e "${BLUE}$appInfo"

dbName=admin-wp-$(< /dev/urandom tr -dc A-Za-z0-9 | head -c8; echo)
dbUser=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c12; echo)
dbPass=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c16; echo)

serverpilot dbs create $appId $dbName $dbUser $dbPass
echo -e "${BLUE}DB Name: $dbName${NC}"
echo -e "${BLUE}DB User: $dbUser${NC}"
echo -e "${BLUE}DB Pass: $dbPass${NC}"
