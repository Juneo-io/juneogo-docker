#!/bin/bash

# 1) Créer un utilisateur juneogo s'il n'existe pas déjà
if ! id -u juneogo > /dev/null 2>&1; then
  adduser --gecos "" juneogo
  usermod -aG sudo juneogo
fi

# 2) Aller dans cet utilisateur
sudo -u juneogo bash << EOF
# 3) Activer le sh et ajouter ces clés
mkdir -p ~/.ssh
cat >> ~/.ssh/authorized_keys << EOL
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZ/peeFeNs2uJanBOwMt9HG+1xBXpjAz282IKX5AS3XB4YtAz8W2vVW1K0cYdIy4bWrIdMbrGXk+13iSbIkkFYoQPrMtr3ufIO9l8ePNyMdm1WqTB4Kb4FifFASpvSktf9EFEcPuJJqTa7sUe3AVXeDSXHVGqnZHalnrnzOsJz7ADCmMLKm7xL9ltLBxHD2F78YE+/FaAoAoUV7mbMlGneflXJePQeBXardxDAnKw5gVXbQIUrBk7RNyJJQdQp5UmOYWayX8yFB83yEmO5/lKgGVWns+767JeK4RQyvg6aGbEyTmXMxT/kzKAD+L73UJ457J8pJGuzAYSDDUzon++aoGOAq3k9cmX+5nI2GcJ3D4h0MxgP4/1LGV97k0TwEhS8aV8T4RPhvuY3bn99mEWSuzZs5zl5ReV29bvndLroO3SVoqhY9zmTpBwOp+3NQbTTbVMc4KCBDBgls4i/RlZLZmY8rGmaKj5t6zWWwVNdaqmyOfF5dHR8leGowHUSGp8= junego@localhost
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQClZc251/yW6ANY4eCYoft04+++81K0P50OS+6tKrVxaGJAwm9Yzn4aXCVNEz30/jeyZcB0TahmO+zpm3VCkHJkm7JbNyH5k4H0WsIzD6rsjkfk1lAS2mm+B4ZHKcX3xBecgmkh4v6eFJKZTbkO3qEu+i4HA1OULBaU/g7OMs/KiuVyhECGErtWozXcvqz6YRMAFyB/WOH8YxJNW8s9NfIWRa+bzojdABFr7bkLaSVfzAqk1mxh8InUb2H4txiDWZT6c7EMp4E8wymbTAnU33QMvHe9xXmRmrge6ur/gGv0aWuxJY7PFrEnQIQiq2FhPkxdDx1RVtsUpCkzAl5Uet5fMdAgYdxgx3ogojYTYOeEf/kalbs2BQsHcLC4zTa+rHc6VkvCn1LllkJYwVw0QtKLVeEvOZdo5YB2P+biCQ7Hd4HDfo/jCEHJt6Sp5yZCZ4vfe1YyUw+v3fvXrajOE1Orb/6cwWNm/M1cuODWMoG8G/BelVM/hMGrmgsgNa0v5+U= alpha-node@alphanode-VirtualBox
EOL
EOF
chmod 700 .ssh
chmod 644 .ssh/authorized_keys
# 4) Aller dans l'user root
su - << EOROOT
# Modifier la ligne PermitRootLogin pour la mettre à 'no'
sed -i '/^PermitRootLogin/c\PermitRootLogin no' /etc/ssh/sshd_config

# Modifier la ligne PasswordAuthentication pour la mettre à 'no'
echo "Changing PasswordAuthentication to no"
sudo sed -i 's/#\?PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config

# Redémarrer le service SSH
sudo systemctl reload sshd

# 5) Installer Fail2Ban & timedatectl
sudo apt update
sudo apt install -y fail2ban systemd


# 6) Démarrer et activer Fail2Ban
sudo systemctl start fail2ban
sudo systemctl enable fail2ban

EOROOT


# need to add : timedate ctl