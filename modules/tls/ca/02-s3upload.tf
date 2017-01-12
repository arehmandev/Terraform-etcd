resource "aws_s3_bucket" "certauthbucket" {
  bucket = "${var.bucketname}"
  acl    = "private"

  tags {
    Name        = "Myyaabdulbucket"
    Environment = "Dev"
  }
}

data "template_file" "kmspolicy" {
  template = "${file("${path.module}/Files/kmspolicy.json.tpl")}"

  vars {
    arn     = "${file("${path.module}/worker_role_arn.txt")}"
    rootarn = "${file("${path.module}/rootarn.txt")}"
  }
}

resource "null_resource" "worker_role_arn" {
  provisioner "local-exec" {
    command = "bash ${path.module}/Files/workarn.sh > ${path.module}/worker_role_arn.txt"
  }
}

resource "null_resource" "arn" {
  provisioner "local-exec" {
    command = "bash ${path.module}/Files/workarn.sh > ${path.module}/rootarn.txt"
  }
}

resource "aws_kms_key" "examplekms" {
  depends_on              = ["data.template_file.kmspolicy"]
  description             = "KMS key 1"
  deletion_window_in_days = 7
  policy                  = "${data.template_file.kmspolicy.rendered}"
}

resource "aws_s3_bucket_object" "certobject" {
  depends_on = ["aws_s3_bucket.certauthbucket", "aws_kms_key.examplekms"]
  bucket     = "${aws_s3_bucket.certauthbucket.bucket}"
  key        = "${var.certobject}"
  source     = "${path.module}/Files/${var.capem}"
  kms_key_id = "${aws_kms_key.examplekms.arn}"
}

resource "aws_s3_bucket_object" "keyobject" {
  depends_on = ["aws_s3_bucket.certauthbucket", "aws_kms_key.examplekms"]
  bucket     = "${aws_s3_bucket.certauthbucket.bucket}"
  key        = "${var.keyobject}"
  source     = "${path.module}/Files/${var.keypem}"
  kms_key_id = "${aws_kms_key.examplekms.arn}"
}
