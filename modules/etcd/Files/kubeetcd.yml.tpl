#cloud-config

coreos:
  etcd2:
    advertise-client-urls: http://$private_ipv4:2379,http://$private_ipv4:4001
    initial-advertise-peer-urls: http://$private_ipv4:2380
    listen-client-urls: http://0.0.0.0:2379,http://0.0.0.0:4001
    listen-peer-urls: http://$private_ipv4:2380,http://$private_ipv4:7001
  locksmith:
    endpoint: "http://localhost:2379"
  update:
    reboot-strategy: "etcd-lock"
  units:
    - name: etcd2.service
      command: stop
    - name: etcd-ssl-keys.service
      command: start
      content: |
        [Unit]
        Description=General SSL certs for etcd
        [Service]
        Restart=on-failure
        RestartSec=300
        ExecStartPre=/usr/bin/docker pull garland/aws-cli-docker:latest
        ExecStartPre=/usr/bin/docker run -v /etc/ssl/etcd/certs:/certs garland/aws-cli-docker aws s3api get-object --bucket ${certauthbucket} --key ${cacertobject} --region=${region} /certs/ca.pem
        ExecStartPre=/usr/bin/docker run -v /etc/ssl/etcd/certs:/certs garland/aws-cli-docker aws s3api get-object --bucket ${etcdbucket} --key ${etcdcertobject} --region=${region} /certs/etcd.pem
        ExecStartPre=/usr/bin/docker run -v /etc/ssl/etcd/private:/certs garland/aws-cli-docker aws s3api get-object --bucket ${etcdbucket} --key ${etcdkeyobject} --region=${region} /certs/etcd.pem
        ExecStart=/usr/bin/chmod 0644 /etc/ssl/etcd/certs/ca.pem /etc/ssl/etcd/certs/etcd.pem /etc/ssl/etcd/private/etcd.pem
    - name: etcd-peers.service
      command: start
      content: |
        [Unit]
        Description=Write a file with the etcd peers that we should bootstrap to
        [Service]
        Restart=on-failure
        RestartSec=10
        ExecStartPre=/usr/bin/docker pull monsantoco/etcd-aws-cluster:latest
        ExecStartPre=/usr/bin/docker run --rm=true -v /etc/sysconfig/:/etc/sysconfig/ monsantoco/etcd-aws-cluster:latest
        ExecStart=/usr/bin/systemctl start etcd2
    - name: fleet.service
      command: start
write_files:
    - path: /etc/systemd/system/etcd2.service.d/30-etcd_peers.conf
      permissions: 0644
      content: |
        [Service]
        EnvironmentFile=/etc/sysconfig/etcd-peers
    - path: /run/systemd/system/etcd.service.d/30-certificates.conf
      permissions: 0644
      content: |
        [Service]
        Environment=ETCD_CA_FILE=/etc/ssl/etcd/certs/ca.pem
        Environment=ETCD_CERT_FILE=/etc/ssl/etcd/certs/etcd.pem
        Environment=ETCD_KEY_FILE=/etc/ssl/etcd/private/etcd.pem
        Environment=ETCD_PEER_CA_FILE=/etc/ssl/etcd/certs/ca.pem
        Environment=ETCD_PEER_CERT_FILE=/etc/ssl/etcd/certs/etcd.pem
        Environment=ETCD_PEER_KEY_FILE=/etc/ssl/etcd/private/etcd.pem
manage_etc_hosts: localhost
