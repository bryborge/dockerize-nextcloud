#!/bin/bash

set -euo pipefail

# stop and remove containers
docker-compose down

# remove volumes
docker volume rm nextcloud_app

#
# Remove local app folders and files?
#
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null 2>&1 && cd .. && pwd )"

printf "\n"
echo "WARNING: YOU'RE ABOUT TO DELETE ALL YOUR DATA!!!"
echo "================================================"
printf "\n"
echo "Do you want to DELETE local 'app' data and .env file?"
read -p "(Enter y or n): " confirm

if [[ "y" == $confirm ]]; then
  echo "Deleting local data ..."
  sudo rm -rf $PROJECT_DIR/app
  rm $PROJECT_DIR/.env
  echo "Complete."
else
  echo "Skipping deletion of local data."
fi
