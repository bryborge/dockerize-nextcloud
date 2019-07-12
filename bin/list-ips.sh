#!/bin/bash

set -euo pipefail

printf "\n"
echo "nextcloud-app:"
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nextcloud-app
printf "\n"
