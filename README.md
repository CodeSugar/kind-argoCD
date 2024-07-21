# kind-argoCD
A simple project to demonstrate the uses of argoCD


---

Intall k9s to see the cluster

wget https://github.com/derailed/k9s/releases/download/v0.32.5/k9s_linux_amd64.deb -P /tmp/
sudo dpkg -i /tmp/k9s_linux_amd64.deb


---

Install terraform 

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

Get initial admin password for ArgoCD

kubectl get secret argocd-initial-admin-secret -n=argocd -o jsonpath='{.data.password}' | base64 --decode

