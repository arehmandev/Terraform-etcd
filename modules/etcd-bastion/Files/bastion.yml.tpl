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
    - name: etcd-peers.service
      command: start
      content: |
        [Unit]
        Description=Write a file with the etcd peers that we should bootstrap to
        [Service]
        Restart=on-failure
        RestartSec=10
        ExecStartPre=/usr/bin/docker pull monsantoco/etcd-aws-cluster:latest
        ExecStartPre=/usr/bin/docker run -e PROXY_ASG=${etcdasg} --rm=true -v /etc/sysconfig/:/etc/sysconfig/ monsantoco/etcd-aws-cluster:latest
        ExecStart=/usr/bin/systemctl start etcd2
    - name: fleet.service
      command: start
write_files:
    - path: /etc/systemd/system/etcd2.service.d/30-etcd_peers.conf
      permissions: 0644
      content: |
        [Service]
        EnvironmentFile=/etc/sysconfig/etcd-peers
manage_etc_hosts: localhost
