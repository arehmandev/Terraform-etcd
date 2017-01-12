# master
resource "aws_iam_role" "master_role" {
  name               = "master_role"
  path               = "/"
  assume_role_policy = "${file("${path.module}/master-role.json")}"
}

resource "null_resource" "master_role" {
  depends_on = ["aws_iam_role.master_role"]

  provisioner "local-exec" {
    command = "echo '${aws_iam_role.master_role.arn}' > ${path.module}/master_role_arn.txt"
  }
}

resource "aws_iam_role_policy" "master_policy" {
  name   = "master_policy"
  role   = "${aws_iam_role.master_role.id}"
  policy = "${file("${path.module}/master-policy.json")}"
}

resource "aws_iam_instance_profile" "master_profile" {
  name  = "master_profile"
  roles = ["${aws_iam_role.master_role.name}"]
}

# worker
resource "aws_iam_role" "worker_role" {
  name               = "worker_role"
  path               = "/"
  assume_role_policy = "${file("${path.module}/worker-role.json")}"
}

resource "aws_iam_role_policy" "worker_policy" {
  name   = "worker_policy"
  role   = "${aws_iam_role.worker_role.id}"
  policy = "${file("${path.module}/worker-policy.json")}"
}

resource "null_resource" "worker_role_arn" {
  depends_on = ["aws_iam_role.worker_role"]

  provisioner "local-exec" {
    command = "echo '${aws_iam_role.worker_role.arn}' > ${path.module}/worker_role_arn.txt"
  }
}

resource "aws_iam_instance_profile" "worker_profile" {
  name  = "worker_profile"
  roles = ["${aws_iam_role.worker_role.name}"]
}
