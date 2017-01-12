output "ca_cert_pem" {
  value = "${tls_self_signed_cert.ca.cert_pem}"
}

output "ca_private_key_pem" {
  value = "${tls_private_key.ca.private_key_pem}"
}

output "ca_bucket_arn" {
  value = "${aws_s3_bucket.certauthbucket.arn}"
}

output "ca_bucket_id" {
  value = "${aws_s3_bucket.certauthbucket.id}"
}
