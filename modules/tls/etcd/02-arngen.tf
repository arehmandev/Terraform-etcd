resource "null_resource" "workerarn" {
  depends_on = ["aws_s3_bucket.etcdbucket"]

  provisioner "local-exec" {
    command = "bash ${path.module}/Files/workerarn.sh > ${path.module}/Files/worker_role_arn.txt"
  }
}

resource "null_resource" "arn" {
  provisioner "local-exec" {
    command = "bash ${path.module}/Files/rootarn.sh > ${path.module}/Files/root_arn.txt"
  }
}

data "template_file" "kmspolicy" {
  depends_on = ["null_resource.arn", "null_resource.workerarn"]
  template   = "${file("${path.module}/Files/kmspolicy.json.tpl")}"

  vars {
    arn     = "${replace(file("${path.module}/Files/worker_role_arn.txt"), "\n", "")}"
    rootarn = "${replace(file("${path.module}/Files/root_arn.txt"), "\n", "")}"
  }
}
