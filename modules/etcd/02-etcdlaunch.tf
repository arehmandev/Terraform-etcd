data "template_file" "kubeetcd" {
  template   = "${file("${path.module}/Files/kubeetcd.tpl")}"
  depends_on = ["null_resource.etcd-discovery-url"]

  vars {
    etcd_discovery_url = "${path.module}/Files/etcd-discovery-url.txt"
  }
}

resource "aws_launch_configuration" "launch_config" {
  name                 = "${var.lc_name}"
  image_id             = "${var.ami_id}"
  instance_type        = "${var.instance_type}"
  iam_instance_profile = "${var.iam_instance_profile}"
  key_name             = "${var.key_name}"
  security_groups      = ["${var.security_group}"]
  user_data            = "${data.template_file.kubeetcd.rendered}"
}

resource "aws_autoscaling_group" "main_asg" {
  depends_on = ["aws_launch_configuration.launch_config"]
  name       = "${var.asg_name}"

  availability_zones  = ["${split(",", var.azs)}"]
  vpc_zone_identifier = ["${split(",", var.subnet_azs)}"]

  launch_configuration = "${aws_launch_configuration.launch_config.id}"

  max_size                  = "${var.asg_number_of_instances}"
  min_size                  = "${var.asg_minimum_number_of_instances}"
  desired_capacity          = "${var.asg_number_of_instances}"
  health_check_grace_period = "${var.health_check_grace_period}"
  health_check_type         = "${var.health_check_type}"
}
