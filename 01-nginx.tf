data "http" "nginx" {
  url = "https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml"
}

data "kubectl_file_documents" "nginx" {
    content = data.http.nginx.response_body
}

resource "kubectl_manifest" "nginx" {
    for_each  = data.kubectl_file_documents.nginx.manifests
    yaml_body = each.value
}