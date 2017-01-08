#cloud-config

coreos:
  etcd2:
    advertise-client-urls: http://$private_ipv4:2379
    initial-advertise-peer-urls: http://$private_ipv4:2380
    listen-client-urls: http://0.0.0.0:2379,http://0.0.0.0:4001
    listen-peer-urls: http://$private_ipv4:2380,http://$private_ipv4:7001
    discovery: $${etcd_discovery_url}
  units:
    - name: etcd2.service
      command: start
    - name: fleet.service
      command: start
  runcmd:
    - output: {all: '| tee -a /var/log/cloud-init-output.log'}
    - curl -L http://127.0.0.1:2379/health
    - wait 60; etcdctl cluster-health
