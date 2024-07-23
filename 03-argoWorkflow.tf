resource "kubectl_manifest" "namespaceArgo" {
    yaml_body = <<YAML
kind: Namespace
apiVersion: v1
metadata:
  name: argo
YAML
}

data "kubectl_file_documents" "argoWorkflowInstall" {
    content = file("03-argoWorkflow-quick-start-minimal.yaml")
}

resource "kubectl_manifest" "argoWorkflowInstall" {
    depends_on = [
        kubectl_manifest.namespaceArgo
    ]
    for_each  = data.kubectl_file_documents.argoWorkflowInstall.manifests
    yaml_body = each.value
}
