# master
resource "aws_iam_role" "master_role" {
  name               = "master_role"
  path               = "/"
  assume_role_policy = "${file("${path.module}/master-role.json")}"
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

resource "aws_iam_instance_profile" "worker_profile" {
  name  = "worker_profile"
  roles = ["${aws_iam_role.worker_role.name}"]
}
