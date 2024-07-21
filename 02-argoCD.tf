data "http" "argoCD" {
  url = "https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
}

data "kubectl_file_documents" "argoInstall" {
    content = file("02-argoCD-install.yaml")
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

data "kubectl_file_documents" "argoConfiguration" {
    content = file("02-argoCD-argocd-cmd-params-cm.yaml")
}

resource "kubectl_manifest" "argoConfiguration" {
    for_each  = data.kubectl_file_documents.argoConfiguration.manifests
    yaml_body = each.value
}

resource "kubectl_manifest" "Argo" {
    depends_on = [
        kubectl_manifest.namespaceArgo,
        kubectl_manifest.argoConfiguration
    ]
    for_each  = data.kubectl_file_documents.argoInstall.manifests
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
  name: argocd-server-http-ingress
  namespace: argocd
  annotations:
#    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
#    nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
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
#    host: argocd.example.com
#  tls:
#  - hosts:
#    - argocd.example.com
#    secretName: argocd-ingress-http
YAML
}