resource "aws_s3_bucket" "etcdbucket" {
  bucket = "${var.bucketname}"
  acl    = "private"

  tags {
    Name        = "EtcdCAbucket"
    Environment = "Dev"
  }
}

data "template_file" "kmspolicy" {
  template = "${file("${path.module}/Files/kmspolicy.json.tpl")}"

  vars {
    accessarn = "${var.accessarn}"
  }
}

resource "aws_kms_key" "examplekms" {
  depends_on              = ["data.template_file.kmspolicy"]
  description             = "KMS key 1"
  deletion_window_in_days = 7
  policy                  = "${data.template_file.kmspolicy.rendered}"
}

resource "aws_s3_bucket_object" "certobject" {
  depends_on = ["aws_s3_bucket.etcdbucket", "aws_kms_key.examplekms"]
  bucket     = "${aws_s3_bucket.etcdbucket.bucket}"
  key        = "${var.certobject}"
  source     = "${path.module}/Files/${var.capem}"
  kms_key_id = "${aws_kms_key.examplekms.arn}"
}

resource "aws_s3_bucket_object" "keyobject" {
  depends_on = ["aws_s3_bucket.etcdbucket", "aws_kms_key.examplekms"]
  bucket     = "${aws_s3_bucket.etcdbucket.bucket}"
  key        = "${var.keyobject}"
  source     = "${path.module}/Files/${var.keypem}"
  kms_key_id = "${aws_kms_key.examplekms.arn}"
}
