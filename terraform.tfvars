### Provider
adminregion = "us-east-2"
adminprofile = "default"
key_name = "terraform"
public_key_path = "~/.ssh/id_rsa.pub"

##### Module base

#VPC Networking
myip = "0.0.0.0/0"
vpc_cidr = "10.0.0.0/16"

# 2 Private CIDRs
private1_cidr = "10.0.0.0/24"
private2_cidr = "10.0.1.0/24"

# 2 Public CIDRs
public1_cidr  = "10.0.2.0/24"
public2_cidr  = "10.0.3.0/24"

# Subnet Availability zones
subnetaz1 = {
  us-east-1 = "us-east-1a"
  us-east-2 = "us-east-2a"
  us-west-1 = "us-west-1a"
  us-west-2 = "us-west-2a"
  eu-west-1 = "eu-west-1a"
  eu-west-2 = "eu-west-2a"
  eu-central-1 = "eu-central-1a"
}

subnetaz2 = {
  us-east-1 = "us-east-1c"
  us-east-2 = "us-east-2b"
  us-west-1 = "us-west-1b"
  us-west-2 = "us-west-2b"
  eu-west-1 = "eu-west-1b"
  eu-west-2 = "eu-west-2b"
  eu-central-1 = "eu-central-1b"
}

### module Etcd

# Launch config
lc_name = "Etcd-lc"
coresize = "t2.micro"
coreami = {
  us-east-1 = "ami-7ee7e169"
  us-east-2 = "ami-f8aaf09d"
  us-west-1 = "ami-f7df8897"
  us-west-2 = "ami-d0e54eb0"
  eu-west-1 = "ami-eb3b6198"
  eu-west-2 = "ami-ebc0ca8f"
  eu-central-1 = "ami-f603c599"
}

# Autoscaling groups
asg_name = "Etcd-asg"
asg_number_of_instances = "3"
asg_minimum_number_of_instances = "3"

bastion_asg_name = "Bastion-asg"
bastion_asg_number_of_instances = "1"
bastion_asg_minimum_number_of_instances = "1"
