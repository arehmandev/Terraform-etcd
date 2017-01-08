resource "tls_private_key" "ca" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "ca" {
  key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.ca.private_key_pem}"

  subject {
    common_name  = "${var.common_name}"
    organization = "${var.organization}"
  }

  allowed_uses = [
    "key_encipherment",
    "cert_signing",
    "server_auth",
    "client_auth",
  ]

  validity_period_hours = "${var.validity_period_hours}"
  early_renewal_hours   = "${var.early_renewal_hours}"
  is_ca_certificate     = "${var.is_ca_certificate}"
  ip_addresses          = ["${var.iplistca}"]
}

resource "null_resource" "keypem" {
  depends_on = ["tls_private_key.ca"]

  provisioner "local-exec" {
    command = "echo '${tls_private_key.ca.private_key_pem}' > ${path.module}/Files/${var.keypem} && chmod 600 ${path.module}/Files/${var.keypem}"
  }
}

resource "null_resource" "capem" {
  depends_on = ["tls_self_signed_cert.ca"]

  provisioner "local-exec" {
    command = "echo '${tls_self_signed_cert.ca.cert_pem}' > ${path.module}/Files/${var.capem} && chmod 600 ${path.module}/Files/${var.capem}"
  }
}
