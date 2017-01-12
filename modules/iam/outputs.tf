# outputs
output "master_profile_name" {
  value = "${aws_iam_instance_profile.master_profile.id}"
}

output "master_profile_arn" {
  value = "${aws_iam_instance_profile.master_profile.arn}"
}

output "worker_profile_name" {
  value = "${aws_iam_instance_profile.worker_profile.id}"
}

output "worker_profile_arn" {
  value = "${aws_iam_instance_profile.worker_profile.arn}"
}
