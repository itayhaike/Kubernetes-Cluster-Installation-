#!/bin/bash
sudo su
git clone https://github.com/Mirantis/cri-dockerd.git

wget https://storage.googleapis.com/golang/getgo/installer_linux

chmod +x ./installer_linux

./installer_linux

source ~/.bash_profile

cd cri-dockerd

mkdir bin

go build -o bin/cri-dockerd

mkdir -p /usr/local/bin

install -o root -g root -m 0755 bin/cri-dockerd /usr/local/bin/cri-dockerd

cp -a packaging/systemd/* /etc/systemd/system sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service

systemctl daemon-reload

systemctl enable cri-docker.service

systemctl enable --now cri-docker.socket

sudo apt update

sudo apt install -y apt-transport-https ca-certificates curl

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update
sudo apt install -y kubelet kubeadm kubectl

sudo apt-mark hold kubelet kubeadm kubectl

sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --cri-socket=unix:///var/run/cri-dockerd.sock

mkdir -p $HOME/.kube

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml

choice = read "You Want to work only in this cluster node?: y/n "
if [choice="y"]; than
    kubectl taint nodes --all node-role.kubernetes.io/control-plane-
elif [choice="n"]; than
    echo "Please enter your kubeadm join from the worker "
else
    echo "!!! Wrong input Enter y/n only !!!"
    

