#!/bin/bash

set -euo pipefail

printf "\n"
echo "nextcloud-app:"
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nextcloud-app
printf "\n"
echo "nextcloud-proxy:"
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nextcloud-proxy
printf "\n"
echo "nextcloud-mariadb:"
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nextcloud-mariadb
printf "\n"
