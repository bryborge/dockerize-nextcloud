#!/bin/bash
#
# This script sets everything up and deploys the application. Upon successful
# deployment, the application will be accessible over http and https.
#
set -euo pipefail

printf "\n"
echo "--- PREFLIGHT: ./docker-compose.yml"
printf "\n"

#
# Check that Compose file exists.
#
if [ -f ./docker-compose.yml ]; then
  echo "Compose file exists, moving on ..."
else
  echo "Unexpected error: Compose file does not exist! Exiting ..."
  exit 1
fi

#
# Check that VIRTUAL_HOST is set.
#
grep 'VIRTUAL_HOST' docker-compose.yml && VH_EXISTS=1 || VH_EXISTS=0
if [ "$VH_EXISTS" == 1 ]; then
  echo "Compose file contains VIRTUAL_HOST, moving on ..."
  printf "\n"
else
  echo "Unexpected error: The Compose file does not contain VIRTUAL_HOST. Exiting ..."
  exit 1
fi

printf "\n"
echo "--- PREFLIGHT: .env and virtual host"
printf "\n"

#
# Check that .env exists, and create it if it doesn't.
#
if [ -f ./.env ]; then
  echo "Environment file exists, moving on ..."
else
  echo "Environment file does not exist!"
  cp ./.env.example ./.env
  echo "Environment file created."
  printf "\n"
fi

#
# Check that virtual host is set, and set it if it isn't (or 'localhost').
#
source ./.env
if [ $VIRTUAL_HOST == localhost ]; then
  echo "Please enter the domain you would like to reach your application at."
  echo "(Example: my-website.dev)"
  printf "\n"
  read -p ">> " DOMAIN
  printf "\n"

  sed -i "s/VIRTUAL_HOST.*/VIRTUAL_HOST=$DOMAIN/" ./.env
  echo "VIRTUAL_HOST has been set to: '$DOMAIN'."
  printf "\n"
fi

printf "\n"
echo "--- BUILD: docker-compose up!"
printf "\n"

#
# Build it.
#
echo "Creating and starting containers, and rebuilding if image is out of date."
printf "\n"
docker-compose up -d --build

printf "\n\n"
echo "--- NETWORKING: Establish network and connect to proxy"
printf "\n"

#
# Check that the project network exists (should be created during build).
#
NETWORK=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nextcloud-app | sed 's/^{"//g' | sed 's/".*$//g')
if [ -z "$NETWORK" ]; then
  echo "Unexpected error: NETWORK cannot be found. Exiting ..."
  exit 1
fi

#
# Attach nginx-proxy to the network.
#
docker network connect "$NETWORK" nginx-proxy 2>/dev/null && echo "Successfully connected $NETWORK to nginx-proxy" || echo "$NETWORK seems to already be attached to nginx-proxy. Moving on ..."
printf "\n"

#
# Check that cert exists, and create if it doesn't.
#
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null 2>&1 && cd .. && pwd )"
CERTS_DIR="$PROJECT_DIR/proxy/certs"

ls "$CERTS_DIR/$DOMAIN.crt" 2>/dev/null && CERT_EXISTS=1 || CERT_EXISTS=0
if [ "$CERT_EXISTS" == 0 ]; then
  echo "$CERTS_DIR/$DOMAIN.crt does not exist. Attempting to generate new certs ..."
  sudo openssl genrsa -out $CERTS_DIR/$DOMAIN.key 2048
  sudo openssl req -new -key $CERTS_DIR/$DOMAIN.key -out $CERTS_DIR/$DOMAIN.csr
  sudo openssl x509 -req -days 9999 -in $CERTS_DIR/$DOMAIN.csr -signkey $CERTS_DIR/$DOMAIN.key -out $CERTS_DIR/$DOMAIN.crt
  sleep 2 # give time for certs to create
else
  echo "$CERTS_DIR/$DOMAIN.crt exists, moving on ..."
fi

#
# Restart nginx-proxy.
#
printf "\n"
echo "Restarting services ..."
docker-compose restart
echo "Restarted."
printf "\n"

#
# Add newly-generated $DOMAIN and $NETWORK to the host's /etc/hosts file.
#
ETC_HOSTS_LINE="$NETWORK $DOMAIN"
grep "$NETWORK *$DOMAIN" /etc/hosts && ETC_HOSTS_MATCH=1 || ETC_HOSTS_MATCH=0
if [ "$ETC_HOSTS_MATCH" == 0 ]; then
  echo "$ETC_HOSTS_LINE does not exist in /etc/hosts"
  echo "Attempting to add it ..."
  sudo bash -c "echo $ETC_HOSTS_LINE >> /etc/hosts"
  printf "\n"
else
  echo "$ETC_HOSTS_LINE exists in /etc/hosts. Moving on ..."
  printf "\n"
fi

#
# Success
#
printf "\n"
echo "--- SUCCESS: Next Steps"
printf "\n"

echo "Your application can be reached at:"
echo "https://$DOMAIN"
echo "https://$NETWORK"
echo "http://$NETWORK"
printf "\n"
