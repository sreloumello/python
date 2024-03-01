#!/bin/bash
# Ubuntu 22.04

# bash-check
if [ -z "$BASH_VERSION" ]; then
    exec bash "$0" "$@"
fi

# root-check
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

# install
set -ex
aptInstall=" \
    apache2-utils \
    apt-utils \
    aptitude \
    atop \
    axel \
    bash-completion \
    build-essential \
    ca-certificates \
    curl \
    diffutils \
    dirmngr \
    dnsutils \
    exfat-fuse \
    exfat-utils \
    file \
    filezilla \
    flameshot \
    fuse \
    gcc \
    git \
    golang \
    gparted \
    hddtemp \
    hdparm \
    htop \
    iotop \
    lm-sensors \
    make \
    mongo-tools \
    mysql-client \
    nano \
    nload \
    net-tools \
    netcat \
    nfs-kernel-server \
    nfs-common \
    nmap \
    ntfs-3g \
    jq \
    openssl \
    openvpn \
    pavucontrol \
    procps \
    python3-pip \
    pwgen \
    rsync \
    snapd \
    software-properties-common \
    sshfs \
    sshpass \
    tcpdump \
    telnet \
    tilix \
    tree \
    unzip \
    vim \
    vlc \
    wget \
    whois \
    x264 \
    x265 \
"
pipInstall=" \
    ansible \
    boto \
    boto3 \
    docker-compose \
"
apt update -q
DEBIAN_FRONTEND=noninteractive apt install -qy $aptInstall
pip3 install $pipInstall
snap install authy

# chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install -y ./google-chrome-stable_current_amd64.deb
rm -f ./google-chrome-stable_current_amd64.deb

# vscode
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
apt install -y apt-transport-https
apt update -q
apt install -y code

# docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# docker-machine
DOCKER_MACHINE_VER=$(curl --silent "https://api.github.com/repos/docker/machine/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
base=https://github.com/docker/machine/releases/download/${DOCKER_MACHINE_VER}
curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine
install /tmp/docker-machine /usr/local/bin/docker-machine

# kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/bin/kubectl
echo "source <(kubectl completion bash)" >> ~/.bashrc

# helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh

# slack
SLACK_VER=$(curl -sL https://slack.com/intl/en-br/downloads/linux | grep -oP '(?<=version_string":")[^"]+')
wget "https://downloads.slack-edge.com/linux_releases/slack-desktop-${SLACK_VER}-amd64.deb"
apt install -y "./slack-desktop-${SLACK_VER}-amd64.deb"
rm -f "./slack-desktop-${SLACK_VER}-amd64.deb"

# spotify
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | apt-key add -
echo "deb http://repository.spotify.com stable non-free" | tee /etc/apt/sources.list.d/spotify.list
apt update -q
apt install -qy spotify-client

# teams
wget -O teams.deb https://packages.microsoft.com/repos/ms-teams/pool/main/t/teams/teams_1.4.00.7556_amd64.deb
apt install -y ./teams.deb
rm -f ./teams.deb

# terraform
TF_VERSION=$(curl -sL https://api.github.com/repos/hashicorp/terraform/releases/latest | jq -r '.tag_name')
TF_URL="https://releases.hashicorp.com/terraform/${TF_VERSION:1}/terraform_${TF_VERSION:1}_linux_amd64.zip"
curl -LO $TF_URL
unzip terraform_${TF_VERSION:1}_linux_amd64.zip
mv terraform /usr/local/bin/
rm -f terraform_${TF_VERSION:1}_linux_amd64.zip

# aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm -rf aws awscliv2.zip

# insomnia
wget -O insomnia.deb https://updates.insomnia.rest/download/linux/deb
apt install -y ./insomnia.deb
rm -f ./insomnia.deb

# discord
wget -O discord.deb "https://discord.com/api/download?platform=linux&format=deb"
apt install -y ./discord.deb
rm -f ./discord.deb

# whatsapp desktop
LATEST_WHATSAPP_VERSION=$(curl -sL https://github.com/whatsdesk/whatsdesk/releases/latest | grep -oP '(?<=tag\/).*(?=")')
wget -O whatsapp.deb "https://github.com/whatsdesk/whatsdesk/releases/download/$LATEST_WHATSAPP_VERSION/WhatsDesk-$LATEST_WHATSAPP_VERSION-amd64.deb"
apt install -y ./whatsapp.deb
rm -f ./whatsapp.deb

# lens
wget -O lens.deb "https://api.k8slens.dev/binaries/latest.yml" && lens_version=$(awk '/version/{print $2}' latest.yml) && lens_url=$(awk '/downloadUrl/{print $2}' latest.yml) && wget -O lens.deb $lens_url && rm -f latest.yml
apt install -y ./lens.deb
rm -f ./lens.deb
