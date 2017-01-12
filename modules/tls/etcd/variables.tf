variable "ca_cert_pem" {}

variable "ca_private_key_pem" {}

variable "validity_period_hours" {
  default = "8760"
}

variable "early_renewal_hours" {
  default = "720"
}

variable "iplistca" {
  type = "list"
}

variable "capem" {}

variable "keypem" {}

### S3 bucket

variable "certobject" {}

variable "keyobject" {}

variable "bucketname" {}

variable "accessarn" {}
