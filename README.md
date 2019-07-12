# Nextcloud (Dockerized)

This is a basic project that makes [Nextcloud](https://nextcloud.com/) deployment a little easier.

## Requirements

*   [Docker](https://docs.docker.com/install/)
*   [Docker Compose](https://docs.docker.com/compose/install/)

## Up and Running

1.  Pull down the repo

    ```sh
    git clone https://github.com/sonofborge/dockerize-nextcloud.git nextcloud
    ```

1.  Create and modify `.env` for your needs.

    ```sh
    cp .env.example .env
    ```

1.  Run Docker Compose

    ```sh
    docker-compose up -d
    ```

1.  To completely eliminate the Nextcloud instance and all associated volumes.

    ```bash
    bash bin/destroy.sh
    ```

## Troubleshooting

Trying to get your iOS device to connect to the server,
but getting a "CSRF Check Failed" message?

Try adding these two lines to your `app/config/config.php`:

```php
<?php
$CONFIG = array (
  ...
  'overwrite.cli.url' => 'https://home.secret-domain.com',
  'overwriteprotocol' => 'https',
  ...
```

Then try adding again.
