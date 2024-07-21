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

data "http" "nginx_test" {
  url = "https://kind.sigs.k8s.io/examples/ingress/usage.yaml"
}

data "kubectl_file_documents" "nginx_test" {
    content = data.http.nginx_test.response_body
}

resource "kubectl_manifest" "nginx_test" {
    depends_on = [
      kubectl_manifest.nginx
    ]
    for_each  = data.kubectl_file_documents.nginx_test.manifests
    yaml_body = each.value
}
