#!/bin/bash

if [ ! -f jammy-server-cloudimg-amd64.img  ]; then
  wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
fi
qm create 9001 --memory 2048 --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci
qm set 9001 --scsi0 ceph-storage:0,import-from=$PWD/jammy-server-cloudimg-amd64.img

qm set 9001 --ide2 ceph-storage:cloudinit
qm set 9001 --boot order=scsi0
qm set 9001 --serial0 socket --vga serial0

curl -sS https://github.com/k-jun.keys > /tmp/k-jun.keys
qm set 9001 --sshkey /tmp/k-jun.keys
qm set 9001 --ciuser k-jun
qm set 9001 --ipconfig0 "ip=dhcp,gw=192.168.11.1"
qm clone 9001 9002

qm resize 9001 scsi0 20G
qm set 9001 --cores 2 --memory 4096
qm template 9001
qm resize 9002 scsi0 50G
qm set 9002 --cores 4 --memory 16384
qm template 9002

qm clone 9001 101 --name k8s-cp01
qm set 101 --ipconfig0 "ip=192.168.11.21/24,gw=192.168.11.1"
qm clone 9001 102 --name k8s-cp02
qm set 102 --ipconfig0 "ip=192.168.11.22/24,gw=192.168.11.1"
qm clone 9001 103 --name k8s-cp03
qm set 103 --ipconfig0 "ip=192.168.11.23/24,gw=192.168.11.1"
qm clone 9002 201 --name k8s-wn01
qm set 201 --ipconfig0 "ip=192.168.11.24/24,gw=192.168.11.1"
qm clone 9002 202 --name k8s-wn02
qm set 202 --ipconfig0 "ip=192.168.11.25/24,gw=192.168.11.1"
qm clone 9002 203 --name k8s-wn03
qm set 203 --ipconfig0 "ip=192.168.11.26/24,gw=192.168.11.1"

for i in 101 102 103 201 202 203; do
  qm start $i
done

qm migrate 102 nipogi02 --online
qm migrate 202 nipogi02 --online
qm migrate 103 nipogi03 --online
qm migrate 203 nipogi03 --online
