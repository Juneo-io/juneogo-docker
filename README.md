# Juneogo-docker

Implementation of docker with the junego application.

# 1. Docker and docker-compose

Please make sure that you have Docker and docker-compose installed on your system. For more information, please refer to their documentation: https://docs.docker.com/get-docker/

# 2. Configure the node:

Copy the files to the server in your home directory with the following command:

```bash
git clone https://github.com/Juneo-io/juneogo-docker
```

By default, your node will not accept remote RPC calls. If you would like to enable remote calls to your node, please expose port `9650` in the `docker-compose.yml` file:

```yml
ports:
  - 9650:9650 # port for API calls - will enable remote RPC calls to your node (mandatory for Supernet/ Blockchain deployers)
```

# 3. Run JuneoGo

You may run JuneoGo using http or https.

## 3.1) Run JuneoGo with HTTP
To run your node with http, please open the juneogo-docker directory in your command line and execute:

```bash
docker-compose build

docker-compose up -d juneogo
```

This will start bootstrapping your node.

## 3.2) Run JuneoGo with HTTPS

To run your node with https, please set up your custom domain to point to your machine's public ip address.

Next, please update the file Caddyfile located in `juneogo-docker/caddy` to contain your domain instead of the sample url.

Example:

```yaml
juneo.node.com {
    reverse_proxy juneogo:9650
}
```

After this, please execute:

```bash
docker-compose build

docker-compose up -d
```

This will start bootstrapping your node.

# 4. Boostrapping status

You can check your node's bootstrapping status with the following RPC call:

```bash
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"info.isBootstrapped",
    "params": {
        "chain":"JUNE"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/info
```

Example response:
```bash
{
  "jsonrpc": "2.0",
  "result": {
    "isBootstrapped": true
  },
  "id": 1
}
```

Once your node has fully boostrapped, navigate to `juneogo-docker/juneogo/` and execute the command in the following format:
```
sudo chown -R [your_user_name] .juneogo/
```

Example (if the user is `juneogo`):
```bash
sudo chown -R juneogo .juneogo/
```

To enter the juneogo Docker container, please execute:
```bash
docker exec -ti juneogo /bin/bash
```