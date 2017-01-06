#!/bin/bash
#### AWS Userdata bash script for bootstrapping kubernetes etcd nodes

#Cert generation
echo "$$cacert" > /etc/etcd/ca.pem
echo "$$etcdcert" > /etc/etcd/kubernetes.pem
echo "$$etcdpem" > /etc/etcd/kubernetes-key.pem

INTERNAL_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
ETCD_NAME=etcd$(echo $$INTERNAL_IP | cut -c 10)

#etcd ips used in template below
#ETCD0_IP=$$etcd0ip
#ETCD1_IP=$$etcd1ip
#ETCD2_IP=$$etcd2ip


wget https://github.com/coreos/etcd/releases/download/v3.0.15/etcd-v3.0.15-linux-amd64.tar.gz
tar -xvf etcd-v3.0.10-linux-amd64.tar.gz
mv etcd-v3.0.10-linux-amd64/etcd* /usr/bin/
mkdir -p /var/lib/etcd

cat > /etc/systemd/system/etcd.service <<"EOF"
[Unit]
Description=etcd
Documentation=https://github.com/coreos

[Service]
ExecStart=/usr/bin/etcd --name ETCD_NAME \
  --cert-file=/etc/etcd/kubernetes.pem \
  --key-file=/etc/etcd/kubernetes-key.pem \
  --peer-cert-file=/etc/etcd/kubernetes.pem \
  --peer-key-file=/etc/etcd/kubernetes-key.pem \
  --trusted-ca-file=/etc/etcd/ca.pem \
  --peer-trusted-ca-file=/etc/etcd/ca.pem \
  --initial-advertise-peer-urls https://INTERNAL_IP:2380 \
  --listen-peer-urls https://INTERNAL_IP:2380 \
  --listen-client-urls https://INTERNAL_IP:2379,http://127.0.0.1:2379 \
  --advertise-client-urls https://INTERNAL_IP:2379 \
  --initial-cluster-token etcd-cluster-0 \
  --initial-cluster etcd0=https://ETCD0_IP:2380,etcd1=https://ETCD1_IP:2380,etcd2=https://ETCD2_IP:2380 \
  --initial-cluster-state new \
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sed -i s/INTERNAL_IP/$${INTERNAL_IP}/g /etc/systemd/system/etcd.service
sed -i s/ETCD_NAME/$${ETCD_NAME}/g /etc/systemd/system/etcd.service
sed -i s/INTERNAL_IP/$${INTERNAL_IP}/g /etc/systemd/system/etcd.service
sed -i s/ETCD0_IP/$${etcd0ip}/g /etc/systemd/system/etcd.service
sed -i s/ETCD1_IP/$${etcd1ip}/g /etc/systemd/system/etcd.service
sed -i s/ETCD2_IP/$${etcd2ip}/g /etc/systemd/system/etcd.service


systemctl daemon-reload
systemctl enable etcd
systemctl start etcd
systemctl status etcd --no-pager
