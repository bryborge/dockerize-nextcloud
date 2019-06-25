# Nextcloud (Dockerized)

This is a basic project that makes [Nextcloud](https://nextcloud.com/) deployment a little easier.

## Requirements

*   [Docker](https://docs.docker.com/install/)
*   [Docker Compose](https://docs.docker.com/compose/install/)
*   [nginx-proxy](https://github.com/sonofborge/dockerize-nginx-proxy)
*   A Linux server to deploy to

## Up and Running

1.  Pull down the repo

    ```sh
    git pull https://github.com/sonofborge/dockerize-nextcloud.git nextcloud
    ```

1.  Create the `.env` file

    ```sh
    cp .env.example .env
    ```

1.  Modify the environment variables to meet your needs (or keep the defaults)

    ```sh
    MYSQL_ROOT_PASSWORD=nextcloud
    MYSQL_PASSWORD=nextcloud
    MYSQL_DATABASE=nextcloud
    MYSQL_USER=nextcloud
    NETWORK_ACCESS=internal
    VIRTUAL_HOST=localhost
    ```

1.  Run Docker Compose

    ```sh
    docker-compose up -d
    ```

That's it!

## Scripts

The `scripts/` directory in this project aid in various operational tasks.
Please read them before executing them.
To my knowledge (and for my purposes) they work fully as intended,
but they may not do what _you_ intend them to do.
You've been warned.
