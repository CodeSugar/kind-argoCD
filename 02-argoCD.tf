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
}

resource "kubectl_manifest" "argoIngress" {
    yaml_body = <<YAML
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-server-ingress
  namespace: default
  annotations:
    nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
spec:
  ingressClassName: nginx
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: argocd-server
            port:
              name: http
YAML
}