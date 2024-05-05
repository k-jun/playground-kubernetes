VIP=192.168.11.40
PRIMARY_CP=192.168.11.21
INTERFACE=eth0
KVVERSION=v0.7.2

if [[ `hostname -I` =~ $PRIMARY_CP ]]; then
    alias kube-vip="ctr image pull ghcr.io/kube-vip/kube-vip:$KVVERSION; ctr run --rm --net-host ghcr.io/kube-vip/kube-vip:$KVVERSION vip /kube-vip"
    kube-vip manifest pod \
      --interface $INTERFACE \
      --address $VIP \
      --controlplane \
      --services \
      --arp \
      --leaderElection | tee /etc/kubernetes/manifests/kube-vip.yaml
    kubeadm init \
      --control-plane-endpoint $VIP \
      --pod-network-cidr=10.244.0.0/16 \
      --upload-certs

    CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
    CLI_ARCH=amd64
    if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
    curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
    sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
    sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
    rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}

    # インストール
    cilium install --version 1.15.2
else
fi
