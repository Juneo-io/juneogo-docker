# Juneogo-docker

Implementation of docker with the junego application.

# Installing Docker

To install Docker on Ubuntu 22.04, follow the instructions available at this address:

```
https://docs.docker.com/engine/install/ubuntu/
```

## Installing docker-compose

To install docker-compose, run the following commands:

```
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo usermod -aG docker junego
sudo chmod 666 /var/run/docker.sock
```

To verify that docker-compose has been installed correctly, run the following command:

```
docker-compose -v
```

# Configure the node:

1. Copy the files to the server at /home/junego (or clone this repo)

2. Change the first line in the caddy/Caddyfile to the correct domain name to be able to use HTTPS.

```
your-domain.com {
    reverse_proxy juneogo:9650
}
```

4. Run the node with HTTPS

```
docker-compose build
docker-compose up -d
```

4.1) Run the node with HTTP

```
docker-compose build
docker-compose up -d juneogo
```

5. Enter into the container:

```
docker exec -ti juneogo /bin/bash
```

Once the files are created, go to the root and do :

```
sudo chown -R junego .juneogo/
```
