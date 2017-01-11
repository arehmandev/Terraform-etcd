resource "null_resource" "iplist" {
  provisioner "local-exec" {
    command = "bash ${path.module}/Files/asgip.sh ${var.asg} > ${path.module}/${var.ipfile}"
  }
}

data "template_file" "init" {
  depends_on = ["null_resource.iplist"]
  template   = "${file("${path.module}/${var.ipfile}")}"
}
