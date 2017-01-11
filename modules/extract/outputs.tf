output "ipcontent" {
  value = "${replace(data.template_file.init.template, "\n", "")}"
}
