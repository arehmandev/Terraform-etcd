# Provider

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

# Subnet Availability zones
variable "subnetaz1" {
  type = "map"
}

variable "subnetaz2" {
  type = "map"
}

#VPC Networking
variable "myip" {}

variable "vpc_cidr" {}

#2 Private subnets
variable "private1_cidr" {}

variable "private2_cidr" {}

#2 Public subnets
variable "public1_cidr" {}

variable "public2_cidr" {}
