# Terraform scripts for a HA etcd Cluster

### Currently the cloud-init script is under development

This script creates:

- A VPC that spans 2 AZs.
- 4 Subnets (2 private, 2 public. 1 of each per AZ).
- An autoscaling group and launch configuration.
- Launch config utlizes EC2 userdata template
- An IAM role for the etcd instances.

To use:

```
1. Modify terraform.tfvars as you wish
2. terraform get && terraform plan
3. terraform apply
```
