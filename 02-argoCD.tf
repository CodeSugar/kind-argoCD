data "http" "argoCD" {
  url = "https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
}

data "kubectl_file_documents" "docs" {
    content = data.http.argoCD.response_body
}

resource "kubectl_manifest" "namespaceArgo" {
    yaml_body = <<YAML
kind: Namespace
apiVersion: v1
metadata:
  name: argocd
YAML
}

resource "kubectl_manifest" "Argo" {
    depends_on = [
        kubectl_manifest.namespaceArgo
    ]
    for_each  = data.kubectl_file_documents.docs.manifests
    yaml_body = each.value
    override_namespace = "argocd"
}

resource "kubectl_manifest" "argoIngress" {
    depends_on = [
      kubectl_manifest.nginx
    ]
    override_namespace = "argocd"
    yaml_body = <<YAML
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$2
spec:
  rules:
  - http:
      paths:
      - pathType: Prefix
        path: /foo(/|$)(.*)
        backend:
          service:
            name: foo-service
            port:
              number: 8080
      - pathType: Prefix
        path: /bar(/|$)(.*)
        backend:
          service:
            name: bar-service
            port:
              number: 8080
YAML
}