# outputs
output "master_profile_name" {
  value = "${aws_iam_instance_profile.master_profile.id}"
}

output "master_role_arn" {
  value = "${file("${path.module}/master_role_arn.txt")}"
}

output "worker_profile_name" {
  value = "${aws_iam_instance_profile.worker_profile.id}"
}

output "worker_role_arn" {
  value = "${file("${path.module}/worker_role_arn.txt")}"
}
