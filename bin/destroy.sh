#!/bin/bash

# stop and remove containers
docker-compose down

# remove volumes
docker volume rm dockerizenextcloud_db
docker volume rm dockerizenextcloud_nextcloud
