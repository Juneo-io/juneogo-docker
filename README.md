# Juneogo-docker
Implementation of docker with the junego application.

# Setting up the server

## Adding a user

```
adduser juneogo
```

## Generating SSH keys
For the first server to be set up you need to generate keys: 

```ssh-keygen```

## Adding the keys
You already have an ssh key pair:

```sudo mkdir .ssh```

⚠️ only use this function if authorized_keys is empty or does not exist

```cat .ssh/id_rsa.pub >> .ssh/authorized_keys```

⚠️ to add your key if the file exists: 
	- either you use nano
	- or with a single '>': 
  
```cat .ssh/id_rsa.pub > .ssh/authorized_keys```


## Changing permissions

```
chmod 700 .ssh

chmod 644 .ssh/authorized_keys
```

## Disabling password authentication and root login
To disable the root login and password authentication, go to the root user:

```
su -
```

Then open the SSH configuration file:

```
nano /etc/ssh/sshd_config
```
Then change the following lines from `yes` to `no`:

```
PermitRootLogin no
PasswordAuthentication no
```

Then reload the SSH service:

```
sudo systemctl reload sshd
```
⚠️ Don't forget to test the connection once you have made these changes! If it doesn't work, definitely don't disconnect.

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

1) Copy the files to the server at /home/junego (or clone this repo)


2) Change this line in the docker-compose to the correct email and domain name 

```
command: bash -c "./obtain-ssl-certificates.sh domain.com email@email.fr && ./juneogo --config-file='.juneogo/config.json'"
```
If you do not specify an email or domain name, the node will work without https

4) Run the node

```
docker-compose build
docker-compose up -d
```

5) Enter into the container: 

```
docker exec -ti juneogo /bin/bash
```

Once the files are created, go to the root and do : 

```
sudo chown -R junego .juneogo/
```

# Install Promeutheus : 

1) Add juneogo to the root :  
```
usermod -aG sudo junego
```
2) Follow this tutorial:
```
https://docs.avax.network/nodes/maintain/setting-up-node-monitoring
```
2.1) Download the script to a user root (not the base root) 
```
wget -nd -m https://raw.githubusercontent.com/ava-labs/avalanche-monitoring/main/grafana/monitoring-installer.sh ;\
chmod 755 monitoring-installer.sh;
```
2.2) Run these 2 commands (after the first one you have to enter the user's password)
```
./monitoring-installer.sh --1
./monitoring-installer.sh --3
```

3) Modify the prometheus config
```
nano etc/prometheus/prometheus.yml 
```
Change lines to work with https (if https set)
```
 - job_name: 'avalanchego'
    metrics_path : '/ext/metrics'
    scheme: https
    static_configs:
       - targets: ['api1.mcnpoc4.xyz:9650']
```
4) Restart the process: 
```
sudo systemctl restart prometheus
```
Then go and check that everything is up: 
```
http://api1.mcnpoc4.xyz:9090/targets?search=
```
