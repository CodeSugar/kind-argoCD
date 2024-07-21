data "kubectl_file_documents" "nginx" {
    content = file("01-nginx-deploy.yaml")
}
resource "kubectl_manifest" "nginx" {
    for_each  = data.kubectl_file_documents.nginx.manifests
    yaml_body = each.value
}
