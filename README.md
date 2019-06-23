# Dockerize Nextcloud

This is a basic project that makes [Nextcloud](https://nextcloud.com/) deployment a little easier.

## Disclaimer

This is not a secure,
production-ready project.
This project is primarily intended to deploy to a local server for home use.

## Requirements

1.  [Docker](https://docs.docker.com/install/)
1.  [Docker Compose](https://docs.docker.com/compose/install/)

## How to Use

To keep from having to type too much,
you can utilize the bash scripts in the `bin/` directory.

*   To spin up a basic Nextcloud instance:

    ```bash
    docker-compose up -d
    ```

*   To completely eliminate the Nextcloud instance and all volumes:

    ```bash
    bash bin/destroy.sh
    ```
