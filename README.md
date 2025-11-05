# K8 Test - Complete CI/CD + GitOps Setup

This repository contains the complete infrastructure setup for the K8 Test application with automated CI/CD and GitOps deployment.

## 🏗️ Architecture

```
Developer → Code Push → GitHub Actions → Docker Image → GitOps Repo → ArgoCD → Kubernetes
```

## 📁 Repository Structure

- **`k8test-repo/`** - Source code, Helm charts, and CI/CD pipeline
- **`k8test-gitops-repo/`** - ArgoCD application definitions and GitOps configuration
- **`root-app.yaml`** - Root ArgoCD application that monitors GitOps repository for changes

## 🚀 Quick Start

### 1. Initial Setup
```bash
# Run the setup script to create Azure infrastructure
./az-setup.bat

# Scaffold the application structure
./scaffold-k8test.bat
```

### 2. Apply GitOps Root Application
```bash
# This enables ArgoCD to automatically monitor GitOps repository changes
kubectl apply -f k8test-gitops-repo/root-app.yaml
```

### 3. Setup GitHub Secrets
Add these secrets to your GitHub repository for CI/CD:
- `CLIENT_ID` - Azure service principal client ID
- `CLIENT_SECRET` - Azure service principal client secret  
- `TENANT_ID` - Azure tenant ID
- `SUBSCRIPTION_ID` - Azure subscription ID
- `GITOPS_TOKEN` - GitHub token with access to GitOps repository

## 🔄 GitOps Flow

1. **Code Changes** → Push to `main` branch in `k8test-repo`
2. **GitHub Actions** → Builds Docker image, pushes to ACR
3. **GitOps Update** → Updates image tag in ArgoCD application manifest
4. **ArgoCD Root App** → Detects change in GitOps repository  
5. **ArgoCD Child App** → Updates Kubernetes deployment automatically
6. **Kubernetes** → Rolls out new version with zero downtime

## 🎯 Key Features

- ✅ **Automated CI/CD** - GitHub Actions pipeline
- ✅ **GitOps Deployment** - ArgoCD with automated sync
- ✅ **Multi-Environment** - Dev, Staging, Production ready
- ✅ **Self-Healing** - ArgoCD automatically fixes configuration drift
- ✅ **Zero Downtime** - Rolling deployments with health checks
- ✅ **Full Observability** - ArgoCD UI for deployment monitoring

## 🌐 Access Points

### ArgoCD UI
```bash
# Start port-forward
kubectl port-forward svc/argocd-server -n argocd 8888:443

# Access at: https://localhost:8888
# Username: admin
# Password: See argocd-password.txt (generated during setup)
```

### Application
```bash
# Port-forward to application
kubectl port-forward -n dev deployment/k8test-dev 3000:3000

# Access at: http://localhost:3000
```

## 📊 Monitoring

- **ArgoCD Applications**: Monitor sync status and health
- **Kubernetes Resources**: Check deployment, service, ingress status  
- **Application Logs**: View pod logs for troubleshooting
- **GitOps History**: Track all configuration changes
- **Elastic Stack (dev)**: ArgoCD syncs `elastic-stack-dev` to provision Elasticsearch, Kibana, Fleet, and a Synthetics agent in the `observability` namespace. Retrieve the bootstrap password with `kubectl get secret elasticsearch-es-elastic-user -n observability -o go-template='{{ .data.elastic | base64decode }}'` and port-forward `svc/kibana-kb-http` to access the Kibana UI locally.

## 🔧 Troubleshooting

### ArgoCD Not Syncing
```bash
# Check application status
kubectl get applications -n argocd

# Force refresh
kubectl patch app k8test-dev -n argocd -p '{"metadata":{"annotations":{"argocd.argoproj.io/refresh":"hard"}}}' --type merge
```

### Application Not Starting  
```bash
# Check pod logs
kubectl logs -n dev deployment/k8test-dev

# Check events
kubectl get events -n dev --sort-by='.metadata.creationTimestamp'
```

## 📝 Version History

- **v1.4.0** - Latest version with enhanced GitOps setup
- **v1.3.0** - Clean deployment demo  
- **v1.2.0** - Full CI/CD pipeline testing
- **v1.1.0** - Initial CI/CD implementation
- **v1.0.0** - Base application setup

## 📚 Documentation

- **[OPERATIONS.md](OPERATIONS.md)** - Complete operations guide with commands and troubleshooting
- **[CHEAT-SHEET.md](CHEAT-SHEET.md)** - Quick reference for daily operations