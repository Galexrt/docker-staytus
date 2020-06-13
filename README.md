# docker-staytus

[![](https://images.microbadger.com/badges/image/galexrt/staytus.svg)](https://microbadger.com/images/galexrt/staytus "Get your own image badge on microbadger.com")

[![Docker Repository on Quay.io](https://quay.io/repository/galexrt/staytus/status "Docker Repository on Quay.io")](https://quay.io/repository/galexrt/staytus)

Image available from:

* [**Quay.io**](https://quay.io/repository/galexrt/staytus)
* [**Docker Hub**](https://hub.docker.com/r/galexrt/staytus)

[adamcooke/staytus](https://github.com/adamcooke/staytus) as a Docker image without the MySQL server.

## Usage

### Versions

* `latest` image tag points to the latest `master` branch build image (see next point).
* `vmaster-*` image tags point to the `master` branch of Staytus repository and are build every month.

### Pulling the image

From quay.io:

```shell
docker pull quay.io/galexrt/staytus:latest
```
Or from Docker Hub:

```shell
docker pull galexrt/staytus:latest
```

### Running Staytus

For the Docker Staytus image to work, you'll need to start a MySQL server (or container).
The commands below creates a network, start a MariaDB and then starts the Staytus container.

Create the separate network for Staytus and database:

```shell
docker network create staytus
```

Start the MariaDB database container:

```shell
docker run \
    -d \
    --name=database \
    --net=staytus \
    -e MYSQL_ROOT_PASSWORD=my-secret-pw \
    -e MYSQL_DATABASE=staytus \
    -e MYSQL_USER=staytus \
    -e MYSQL_PASSWORD=staytus \
    mariadb:10.4-focal
```

Start the Staytus container with the environment variables pointing to the created `database` container.

```shell
docker run \
    -d \
    --name=staytus \
    --net=staytus \
    -p 8787:8787 \
    -e 'DB_HOST=database' \
    -e 'DB_USER=staytus' \
    -e 'DB_PASSWORD=staytus' \
    quay.io/galexrt/staytus:latest
```

After running the commands, open `127.0.0.1:8787`, `YOUR_IP:8787` (or the server IP when Docker is running on a server) in your browser to run the setup for your containerized Staytus instance.

#### Manual configuration

If you want to manually configure Staytus, you can point a volume to `/opt/staytus/staytus/config/`  and put the `database.yaml` config in that volume yourself.

```shell
docker run \
[...]
    -e 'AUTO_CONF=false' \
    -v /opt/docker/staytus/config:/opt/staytus/staytus/config:ro \
[...]
quay.io/galexrt/staytus:lastest
```

### Available Env Vars

#### Database Configuration

> **NOTE**
>
> Database setup instructions here https://github.com/adamcooke/staytus#instructions

You can add the following variables as env vars to your Docker run command:

* `AUTO_CONF` (Default: `true`) - Enable or disable the `database.yaml` configuration, based on the upcoming `DB_*` variables.
* `DB_ADAPTER` (Default: `mysql2`)
* `DB_POOL` (Default: `5`)
* `DB_HOST` (Default: `database`)
* `DB_DATABASE` (Default: `staytus`)
* `DB_USER` (Default: `staytus`)
* `DB_PASSWORD` (Default: empty)

#### SMTP Configuration (from Staytus)

You can add the following variables as env vars to your Docker run command:

* `STAYTUS_SMTP_HOSTNAME`
* `STAYTUS_SMTP_USERNAME`
* `STAYTUS_SMTP_PASSWORD`
