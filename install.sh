#!/bin/bash
#sudo check
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

#update and install docker 
apt update && apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
groupadd docker
usermod -aG docker $USER
chmod 666 /var/run/docker.sock
docker run -d \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  --name jenkins \
  --restart=on-failure \
  jenkins/jenkins:lts-jdk21

#setting jenkins container with docker git and trivy
docker exec -u -it root jenkins bash -c "
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
apt install -y git
apt-get install -y curl wget tar ca-certificates
LATEST=$(curl -s https://api.github.com/repos/aquasecurity/trivy/releases/latest | grep tag_name | cut -d '"' -f 4)
echo "Latest version: $LATEST"
wget https://github.com/aquasecurity/trivy/releases/download/${LATEST}/trivy_${LATEST#v}_Linux-64bit.tar.gz
groupadd docker
usermod -aG docker $USER
chmod 666 /var/run/docker.sock
"
curl -sfL https://get.k3s.io | sh -
sudo cp /etc/rancher/k3s/k3s.yaml $HOME/k3s.yaml
sudo chown $USER:$USER $HOME/k3s.yaml
echo "export KUBECONFIG=$HOME/k3s.yaml" >> ~/.bashrc
source ~/.bashrc

apt install -y helm

#argo rollouts
kubectl apply -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
curl -LO https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-linux-amd64
sudo install kubectl-argo-rollouts-linux-amd64 /usr/local/bin/kubectl-argo-rollouts