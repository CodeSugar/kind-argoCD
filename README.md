# kind-argoCD

A project to demonstrate the uses of Terraform ( IaaC ), KinD ( Kubernetes in Docker ) and Argo. 

All the setup can be run in Github Copilot, features:

- Initialize the Kubernetes Cluster using Terraform
- Setup Nginx Ingress in the Cluster
- Setup ArgoCD in the cluster
- Ingress definition for ArgoCD using Nginx
- Add KinD load balancer
- Add argo Workflows 


Future features

- Add example http endpoint using KinD Loadbalancer
- Add visualization for Kubernetes Cluster
- Add users roles for ArgoCD
- Add argoCD projects


---

### Install k9s to see the cluster

wget https://github.com/derailed/k9s/releases/download/v0.32.5/k9s_linux_amd64.deb -P /tmp/
sudo dpkg -i /tmp/k9s_linux_amd64.deb


---

### Install terraform 

sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt-get install terraform


---

### Get initial admin password for ArgoCD

kubectl get secret argocd-initial-admin-secret -n=argocd -o jsonpath='{.data.password}' | base64 --decode

---

### Install Kind cloud provider

mkdir /tmp/cloud-provider-kind

wget https://github.com/kubernetes-sigs/cloud-provider-kind/releases/download/v0.3.0/cloud-provider-kind_0.3.0_linux_amd64.tar.gz -P /tmp/cloud-provider-kind/

tar -xzvf /tmp/cloud-provider-kind/cloud-provider-kind_0.3.0_linux_amd64.tar.gz  -C /tmp/cloud-provider-kind/