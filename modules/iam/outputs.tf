# outputs
output "master_profile_name" {
  value = "${aws_iam_instance_profile.master_profile.id}"
}

output "worker_profile_name" {
  value = "${aws_iam_instance_profile.worker_profile.id}"
}
