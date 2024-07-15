terraform {
  required_providers {
    kind = {
      source = "tehcyx/kind"
      version = "0.5.1"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    http = {
      source = "hashicorp/http"
      version = "3.4.3"
    }
  }
}