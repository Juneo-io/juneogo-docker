# Juneogo-docker
Implementation of docker with the junego application.

# Paramètrage du serveur

## Ajout d'un utilisateur
adduser junego


## Génération de clés SSH
Pour le premier serveur à setup il faut générer des clés : 

```ssh-keygen```

## Autorisation de la clé
Quand tu as déjà tes clés :

```sudo mkdir .ssh```

⚠️ utiliser cette fonction uniquement si authorized_keys est vide ou n'existe pas

```cat .ssh/id_rsa.pub >> .ssh/authorized_keys```

⚠️ pour rajouter ta clé si le fichier existe : 
	- soit tu utilise nano
	- soit avec un seul '>' : 
  
```cat .ssh/id_rsa.pub > .ssh/authorized_keys```


## Modification des permissions

```
chmod 700 .ssh

chmod 644 .ssh/authorized_keys
```

## Désactivation de l'authentification par mot de passe et du login root
Ensuite, pour désactiver le root login et l'authentification par mot de passe, il faut aller dans l'utilisateur root:

```
su -
```

Puis ouvrir le fichier de configuration de SSH:

```
nano /etc/ssh/sshd_config
```
Il faut ensuite modifier les lignes suivantes en passant de `yes` à `no`:

```
PermitRootLogin no
PasswordAuthentication no
```

Puis recharger le service SSH:

```
sudo systemctl reload sshd
```
⚠️ N'oublie pas de tester la connexion une fois ces modifications apportées! Si cela ne fonctionne pas, il ne faut absolument pas se déconnecter.

# Installation de Docker

Pour installer Docker sur Ubuntu 22.04, suis les instructions disponibles à cette adresse:

https://docs.docker.com/engine/install/ubuntu/

## Installation de docker-compose

Pour installer docker-compose, exécute les commandes suivantes:

```
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo usermod -aG docker junego
sudo chmod 666 /var/run/docker.sock
```


Pour vérifier que docker-compose a été correctement installé, exécute la commande suivante:

```
docker-compose -v
```

# Lancer le noeud :

1) Copier les fichiers dans le serveur à l'emplacement /home/junego
2) modifier le fichier obtain-ssl-certificates.sh en changeant l'email et le domain name
```
certbot certonly --standalone --agree-tos --preferred-challenges http-01 --email email@email.com -d mondomaine.com
```

3) modifier cette ligne du dockerCompose en mettant le bon nom de domaine 

```
command:  bash -c "./obtain-ssl-certificates.sh domain.com && ./juneogo --config-file='.juneogo/config.json'"
```

4) Lancer le noeud

```
docker-compose build
docker-compose up -d
```

5) rentrer dans le container : 

```
docker exec -ti juneogo /bin/bash
```

une fois les fichiers créé il faut aller dans le root et faire : 

```
sudo chown -R junego .juneogo/
```

# Installer Promeutheus : 

1) ajouter juneogo aux root : 
```
usermod -aG sudo junego
```
2) suivre ce tuto :
```
https://docs.avax.network/nodes/maintain/setting-up-node-monitoring
```
2.1) download le scrip dans un user root (pas le root de base ) 
```
wget -nd -m https://raw.githubusercontent.com/ava-labs/avalanche-monitoring/main/grafana/monitoring-installer.sh ;\
chmod 755 monitoring-installer.sh;
```
2.2) lancer ces 2 commandes ( après la 1 er il faut rentrer le mdp du user)
```
./monitoring-installer.sh --1
./monitoring-installer.sh --3
```

3) modif la config prometheus
```
nano etc/prometheus/prometheus.yml 
```
changer les lignes pour que ça fonctionne avec le https (si https mis)
```
 - job_name: 'avalanchego'
    metrics_path : '/ext/metrics'
    scheme: https
    static_configs:
       - targets: ['api1.mcnpoc4.xyz:9650']
```
4) Restart le processus : 
```
sudo systemctl restart prometheus
```
ensuite aller vérifier sur que tout soit up : 
```
http://api1.mcnpoc4.xyz:9090/targets?search=
```
