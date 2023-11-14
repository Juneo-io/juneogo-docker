# Juneogo-docker

Implementation of docker with the junego application.

# 1. Installing Docker

Please make sure that you have Docker and Docker Compose on your system. For more information, please refer to the docker documentation: https://docs.docker.com/get-docker/

# 2. Configure the node:

Copy the files to the server in your home directory with the following command:

```bash
git clone https://github.com/Juneo-io/juneogo-docker
```

By default, your node will accept remote RPC calls. If you would like to disable remote calls to your node, please remove the following line in the docker-compose.yml file:

```yml
- 9650:9650 # 9650 for api - comment out this line to disable RPC calls to your node (not recommended for Supernet/Chain deployers)
```

# 3. Run JuneoGo

You may run JuneoGo using http or https.

## 3.1) Run JuneoGo with HTTP
If you would like to start your node using http, please open the juneogo-docker directory in your command line and execute:

```bash
docker-compose build

docker-compose up -d juneogo
```

This will start bootstrapping your node, and will have remote RPC calls enabled via your machine’s public IP address.

## 3.2) Run JuneoGo with HTTPS

If you would like to start your node using https, please set up your custom domain to point to your machine's public ip address.

Next, please update the file Caddyfile located in juneogo-docker/caddy to contain your domain instead of the sample url.

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

This will start bootstrapping your node, and will have remote RPC calls enabled via your machine’s public IP address.

# 4. Bootstrapping status

You can check if your node is bootstrapped with the following call:
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

To enter your container, please execute:
```bash
docker exec -ti juneogo /bin/bash
```

Once the files are created, go to the root and execute the command in the following format:
```
sudo chown -R [your_user_name] .juneogo/
```

Example (if the user is `juneogo`):
```bash
sudo chown -R juneogo .juneogo/
```
