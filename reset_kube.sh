#!/bin/bash
echo "Important!!!!!!"
sleep 1
echo "!!!Make sure you edit the file: 'sudo visudo' by this template: $(whoami) ALL=(ALL) NOPASSWD:ALL !!!\n and group:"
' %sudo  ALL=(ALL:ALL) NOPASSWD:ALL '
sleep 4
sudo nano /etc/sudoers
sleep 2


sudo kubeadm reset --cri-socket=/var/run/cri-dockerd.sock

sudo rm -r  ~/.kube

sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --cri-socket=unix:///var/run/cri-dockerd.sock

mkdir -p $HOME/.kube

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml

sleep 1

#kubectl taint nodes --all node-role.kubernetes.io/control-plane-
