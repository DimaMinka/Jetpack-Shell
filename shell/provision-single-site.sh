#!/bin/bash

source /home/vagrant/.bash_profile

RED='\033[0;31m'
PURPLE='\033[0;35m'
BLUE='\033[1;34m'
GREEN='\033[1;32m'
NC='\033[0m'

echo -e "${GREEN}Serverpilot app provision${NC}"
echo -e "${RED}Please enter the name of the app:${NC}"
read -r app_name

while [ "$php_version" != "php5.4" ] && [ "$php_version" != "php5.5" ] && [ "$php_version" != "php5.6" ] && [ "$php_version" != "php7.0" ] && [ "$php_version" != "php7.1" ] && [ "$php_version" != "php7.2" ]; do
        echo -e "${RED}Please select which version of PHP (php5.4, php5.5, php5.6, php7.0, or php7.1, or php7.2):${NC}"
        read -r php_version
done

echo -e "${RED}Please enter a domain to use for the site:${NC}"
read -r domain

appId=$(serverpilot find apps serverid=$serverpilot_server_id,name=$app_name id)
if [ ! -z "$appId" ]; then
        echo -e "${RED}The app exist. Try again${NC}"
        exit 1;
fi

result=$( serverpilot apps create "$app_name" "$serverpilot_user_id" "$php_version" '["'"$domain"'"]')

echo $result

appId=$(serverpilot find apps serverid=$serverpilot_server_id,name=$app_name id)
appInfo=$(serverpilot apps $appId)

echo -e "${BLUE}$appInfo"

dbName=$app_name-wp-$(< /dev/urandom tr -dc A-Za-z0-9 | head -c8; echo)
dbUser=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c12; echo)
dbPass=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c16; echo)

serverpilot dbs create $appId $dbName $dbUser $dbPass
echo -e "${BLUE}DB Name: $dbName${NC}"
echo -e "${BLUE}DB User: $dbUser${NC}"
echo -e "${BLUE}DB Pass: $dbPass${NC}"
