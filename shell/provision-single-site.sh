#!/bin/bash

source /home/vagrant/.bash_profile

# RED='\033[0;31m'
# PURPLE='\033[0;35m'
# BLUE='\033[1;34m'
# GREEN='\033[1;32m'
# NC='\033[0m'

echo "Please enter the name of the app:"
read -r app_name

while [ "$php_version" != "php5.4" ] && [ "$php_version" != "php5.5" ] && [ "$php_version" != "php5.6" ] && [ "$php_version" != "php7.0" ] && [ "$php_version" != "php7.1" ] && [ "$php_version" != "php7.2" ]; do
        echo "Please select which version of PHP (php5.4, php5.5, php5.6, php7.0, or php7.1, or php7.2):"
        read -r php_version
done

echo "Please enter a domain to use for the site:"
read -r domain

result=$( serverpilot apps create "$app_name" "$serverpilot_user_id" "$php_version" '["'"$domain"'"]')

echo "$result"
