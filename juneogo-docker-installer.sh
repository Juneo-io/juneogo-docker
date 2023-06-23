#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# 1) Create a new user and add it to the sudo groupy
if ! id -u juneogo > /dev/null 2>&1; then
  adduser --gecos "" juneogo
  usermod -aG sudo juneogo
fi

# Ask if the user wants to overwrite the SSH keys
read -p "Do you want to overwrite the SSH keys? (y/n) " overwrite_ssh
if [ "$overwrite_ssh" != "y" ]; then
  echo "Skipping SSH keys..."
  overwrite_ssh="no"
fi

# 2) Enable ssh key authentication
if [ "$overwrite_ssh" = "y" ]; then
  mkdir -p /home/juneogo/.ssh
  cat > /home/juneogo/.ssh/authorized_keys << EOL
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZ/peeFeNs2uJanBOwMt9HG+1xBXpjAz282IKX5AS3XB4YtAz8W2vVW1K0cYdIy4bWrIdMbrGXk+13iSbIkkFYoQPrMtr3ufIO9l8ePNyMdm1WqTB4Kb4FifFASpvSktf9EFEcPuJJqTa7sUe3AVXeDSXHVGqnZHalnrnzOsJz7ADCmMLKm7xL9ltLBxHD2F78YE+/FaAoAoUV7mbMlGneflXJePQeBXardxDAnKw5gVXbQIUrBk7RNyJJQdQp5UmOYWayX8yFB83yEmO5/lKgGVWns+767JeK4RQyvg6aGbEyTmXMxT/kzKAD+L73UJ457J8pJGuzAYSDDUzon++aoGOAq3k9cmX+5nI2GcJ3D4h0MxgP4/1LGV97k0TwEhS8aV8T4RPhvuY3bn99mEWSuzZs5zl5ReV29bvndLroO3SVoqhY9zmTpBwOp+3NQbTTbVMc4KCBDBgls4i/RlZLZmY8rGmaKj5t6zWWwVNdaqmyOfF5dHR8leGowHUSGp8= junego@localhost
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQClZc251/yW6ANY4eCYoft04+++81K0P50OS+6tKrVxaGJAwm9Yzn4aXCVNEz30/jeyZcB0TahmO+zpm3VCkHJkm7JbNyH5k4H0WsIzD6rsjkfk1lAS2mm+B4ZHKcX3xBecgmkh4v6eFJKZTbkO3qEu+i4HA1OULBaU/g7OMs/KiuVyhECGErtWozXcvqz6YRMAFyB/WOH8YxJNW8s9NfIWRa+bzojdABFr7bkLaSVfzAqk1mxh8InUb2H4txiDWZT6c7EMp4E8wymbTAnU33QMvHe9xXmRmrge6ur/gGv0aWuxJY7PFrEnQIQiq2FhPkxdDx1RVtsUpCkzAl5Uet5fMdAgYdxgx3ogojYTYOeEf/kalbs2BQsHcLC4zTa+rHc6VkvCn1LllkJYwVw0QtKLVeEvOZdo5YB2P+biCQ7Hd4HDfo/jCEHJt6Sp5yZCZ4vfe1YyUw+v3fvXrajOE1Orb/6cwWNm/M1cuODWMoG8G/BelVM/hMGrmgsgNa0v5+U= alpha-node@alphanode-VirtualBox
EOL
  chmod 700 /home/juneogo/.ssh
  chmod 644 /home/juneogo/.ssh/authorized_keys
  chown -R juneogo:juneogo /home/juneogo/.ssh

  # update sshd_config to disable root login
  sed -i '/^PermitRootLogin/c\PermitRootLogin no' /etc/ssh/sshd_config

  # Update PasswordAuthentication to no
  echo "Changing PasswordAuthentication to no"
  sudo sed -i 's/#\?PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config

  # Restart SSH
  sudo systemctl reload sshd
fi

# 5) install fail2ban & systemd (for timedatectl)
sudo apt update
sudo apt install -y fail2ban systemd

# 6) start & enable fail2ban
sudo systemctl start fail2ban
sudo systemctl enable fail2ban

# Prompt user to install Docker or not
read -p "Do you want to install Docker? (y/n) " install_docker
if [ "$install_docker" = "y" ]; then
  sudo apt-get remove docker docker-engine docker.io containerd runc docker-compose
  sudo apt-get update
  sudo apt-get install ca-certificates  curl  gnupg  lsb-release -y
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose -y
  sudo usermod -aG docker juneogo
  sudo chmod 666 /var/run/docker.sock  
fi

# Prompt user to install certbot or not
read -p "Do you want to install Certbot? (y/n) " install_certbot
if [ "$install_certbot" = "y" ]; then
  sudo apt update
  sudo apt install snapd -y
  sudo snap install --classic certbot -y
  sudo ln -s /snap/bin/certbot /usr/bin/certbot
  sudo certbot --version
fi

# Prompt user to clone repository
read -p "Do you want to clone Juneogo docker repository? (y/n) " clone_repo
if [ "$clone_repo" = "y" ]; then
  # Change to /home/juneogo directory
  cd /home/juneogo

  # Clone the repository
  git clone https://github.com/Juneo-io/juneogo-docker
  sudo chmod +x juneogo-docker/juneogo/config.sh juneogo-docker/juneogo/juneogo juneogo-docker/juneogo/plugins/jevm juneogo-docker/juneogo/obtain-ssl-certificates.sh
  sudo chown juneogo -Rf juneogo-docker/
fi