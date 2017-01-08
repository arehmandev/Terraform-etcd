# Terraform scripts for a HA etcd Cluster

### This script creates:

- 3 x t2.micro CoreOS EC2 instances
- A VPC that spans 2 AZs.
- 4 Subnets (2 private, 2 public. 1 of each per AZ) - the etcd instances are by default configured to private subnets
- An autoscaling group and launch configuration.
- Launch config utlizes EC2 userdata template
- EC2 userdata = cloud-init + local etcd discovery URL generation
- EC2 security groups, egress = all traffic, ingress locked internally to VPC and variable "myip" (default == 0.0.0.0/0 in tfvars)
- An IAM role for the etcd instances.

### To use:

Pre-requisites: Terraform, AWS CLI and SSH Keys

```
1. Modify terraform.tfvars as you wish
2. terraform get && terraform plan
3. terraform apply
```

### Extra steps:

Change "myip" in tfvars to your ip to lockdown public instance IPs

###Version info:

 Working and Tested as of 08/01/17
 Terraform version: 0.8.2

### Features to implement in the future:

Etcd discovery as described here:
http://engineering.monsanto.com/2015/06/12/etcd-clustering/

TLS certs - already underway
