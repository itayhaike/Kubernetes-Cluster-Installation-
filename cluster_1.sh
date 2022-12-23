#!/bin/bash
echo "Important!!!!!!"

echo " Make sure you edit the file: 'sudo visudo' by this template: $(howami) ALL=(ALL) NOPASSWD:ALL "

sleep 3
edit = read "Did you edit visudo file? y/n"
if [edit=n]; then
    echo "You must to edit to continue the process!!!"
    exit 0
elif [edit=y]; then
    sudo apt update
    sudo apt install net-tools
    sudo apt install openssh-server openssh-client

    sudo ufw allow 6443/tcp
    sudo ufw allow 2379/tcp
    sudo ufw allow 2380/tcp
    sudo ufw allow 10250/tcp
    sudo ufw allow 10257/tcp
    sudo ufw allow 10259/tcp
    sudo ufw reload

    cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf br_netfilter EOF

    cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf net.bridge.bridge-nf-call-ip6tables = 1 net.bridge.bridge-nf-call-iptables = 1 net.ipv4.ip_forward = 1 EOF

    echo "in the file you need to disable swap like this : #/swapfile "
    sleep 1
    sudo nano /etc/fstab

    sudo sysctl --system

    sudo apt update
    sudo apt install -y ca-certificates curl gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list

    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo usermod -aG docker $USER

    echo "the system will reboot now, after reboot run the file: cluster_.sh"
    sleep 3
    sudo reboot
else
    echo "Enter only y/n input!!!"

