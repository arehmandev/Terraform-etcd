provider "aws" {
  region  = "${var.adminregion}"
  profile = "${var.adminprofile}"
}

module "base" {
  source          = "./modules/base"
  adminregion     = "${var.adminregion}"
  adminprofile    = "${var.adminprofile}"
  key_name        = "${var.key_name}"
  public_key_path = "${var.public_key_path}"

  #Locking down Security Groups to your ip
  myip = "${var.myip}"

  vpc_cidr      = "${var.vpc_cidr}"
  private1_cidr = "${var.private1_cidr}"
  private2_cidr = "${var.private2_cidr}"
  public1_cidr  = "${var.public1_cidr}"
  public2_cidr  = "${var.public2_cidr}"

  subnetaz1 = "${var.subnetaz1}"
  subnetaz2 = "${var.subnetaz2}"
}

module "iam" {
  source = "./modules/iam"
}

module "etcd" {
  source               = "./modules/etcd"
  lc_name              = "${var.lc_name}"
  ami_id               = "${lookup(var.coreami, var.adminregion)}"
  instance_type        = "${var.coresize}"
  iam_instance_profile = "${module.iam.worker_profile_name}"
  key_name             = "${var.key_name}"
  security_group       = "${module.base.aws_security_group.default.id}"

  asg_name                        = "${var.asg_name}"
  asg_number_of_instances         = "${var.asg_number_of_instances}"
  asg_minimum_number_of_instances = "${var.asg_minimum_number_of_instances}"

  azs        = ["${lookup(var.subnetaz1, var.adminregion)}", "${lookup(var.subnetaz2, var.adminregion)}"]
  subnet_azs = ["${module.base.aws_subnet.private1.id}", "${module.base.aws_subnet.private2.id}"]

  # To have the etcd instances in public subnets:

  #subnet_azs = ["${module.base.aws_subnet.public1.id}", "${module.base.aws_subnet.public2.id}"]
}
