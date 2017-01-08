resource "null_resource" "etcd-discovery-url" {
  provisioner "local-exec" {
    command = "curl -s https://discovery.etcd.io/new?size=${var.asg_number_of_instances} > ${path.module}/Files/etcd-discovery-url.txt"
  }
}
