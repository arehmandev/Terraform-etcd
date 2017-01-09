### Provider
variable "adminregion" {}

variable "adminprofile" {}

variable "key_name" {}

variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"

  description = <<DESCRIPTION
Path to the SSH public key for authentication.
Example: ~/.ssh/id_rsa.pub
DESCRIPTION
}

### Base modules

#VPC Networking
variable "myip" {}

variable "vpc_cidr" {}

# 2 Private CIDRs
variable "private1_cidr" {}

variable "private2_cidr" {}

# 2 Public CIDRs
variable "public1_cidr" {}

variable "public2_cidr" {}

# Subnet Availability zones

variable "subnetaz1" {
  type = "map"
}

variable "subnetaz2" {
  type = "map"
}

### Etcd module

# Launch config
variable "lc_name" {}

variable "coresize" {}

variable "coreami" {
  type = "map"
}

# Autoscaling groups

variable "asg_name" {}

variable "asg_number_of_instances" {}

variable "asg_minimum_number_of_instances" {}

variable "bastion_asg_name" {}

variable "bastion_asg_number_of_instances" {}

variable "bastion_asg_minimum_number_of_instances" {}
