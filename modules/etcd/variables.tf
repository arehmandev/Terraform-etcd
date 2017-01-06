### Module etcd

variable "lc_name" {}

variable "ami_id" {}

variable "instance_type" {}

variable "iam_instance_profile" {}

variable "key_name" {}

variable "security_group" {
  description = "The security group the instances to use"
}

variable "asg_name" {}

variable "asg_number_of_instances" {
  description = "The number of instances we want in the ASG"
}

variable "asg_minimum_number_of_instances" {
  description = "The minimum number of instances the ASG should maintain"
  default     = 1
}

variable "health_check_grace_period" {
  description = "Number of seconds for a health check to time out"
  default     = 300
}

variable "health_check_type" {
  default = "EC2"
}

variable "subnet_azs" {
  description = "The VPC subnet IDs"

  // comma separated list
}

variable "azs" {
  description = "Availability Zones"

  // comma separated list
}
