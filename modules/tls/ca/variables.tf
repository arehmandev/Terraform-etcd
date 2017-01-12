variable "organization" {
  default = "apollo"
}

# valid for 1000 days
variable "validity_period_hours" {
  default = 24000
}

variable "early_renewal_hours" {
  default = 720
}

variable "is_ca_certificate" {
  default = true
}

variable "common_name" {
  default = "kube-ca"
}

# names of the pem files generated defined when the module is called and the IP settings for CA
variable "capem" {}

variable "iplistca" {
  type = "list"
}

variable "keypem" {}

### S3 bucket

variable "certobject" {}

variable "keyobject" {}

variable "bucketname" {}
