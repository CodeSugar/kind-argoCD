provider "kind" {}

# Create a cluster
resource "kind_cluster" "default" {
  name = "test-cluster"

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"

      kubeadm_config_patches = [
        "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\"\n"
      ]

      extra_port_mappings {
        container_port = 80
        host_port      = 8080
      }
      extra_port_mappings {
        container_port = 443
        host_port      = 4443
      }
    }

    #node {
    #    role = "worker"
    #}
  }
}

#We enable the provider once the cluster is created
provider "kubectl" {
  # Configuration options, we import the cluster generated in 01
  config_path = kind_cluster.default.kubeconfig_path
  load_config_file       = true 
}