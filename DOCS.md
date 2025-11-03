# 📁 K8 Test - Documentation Index

This folder contains the complete K8 Test application with CI/CD and GitOps setup. Here's your documentation guide:

## 🚀 Getting Started
- **[az-setup.bat](az-setup.bat)** - Azure infrastructure setup script
- **[scaffold-k8test.bat](scaffold-k8test.bat)** - Application scaffolding script  
- **[README.md](README.md)** - Complete project overview and architecture

## 📋 Daily Operations  
- **[CHEAT-SHEET.md](CHEAT-SHEET.md)** - ⭐ **Quick reference for daily commands**
- **[OPERATIONS.md](OPERATIONS.md)** - Detailed operations manual with troubleshooting
- **[LENS-GUIDE.md](LENS-GUIDE.md)** - Kubernetes Lens GUI setup and usage
- **[health-check.bat](health-check.bat)** - Quick health check script

## 📁 Project Structure
```
📦 k8 test/
├── 🔧 az-setup.bat              # Azure infrastructure setup
├── 🏗️ scaffold-k8test.bat       # App scaffolding  
├── ❤️ health-check.bat          # Health check script
├── 📖 README.md                 # Project overview
├── 📋 CHEAT-SHEET.md           # Quick reference ⭐
├── 🛠️ OPERATIONS.md            # Operations manual
├── 📁 k8test-repo/             # Source code & CI/CD
└── 📁 k8test-gitops-repo/      # ArgoCD GitOps config
```

## 🎯 Most Used Commands

### Daily Essentials
```bash
# Check everything
kubectl get applications -n argocd && kubectl get pods -n dev

# Access ArgoCD UI  
kubectl port-forward svc/argocd-server -n argocd 8888:443

# Access application
kubectl port-forward -n dev deployment/k8test-dev 3000:3000
```

### When Things Go Wrong
```bash
# Force ArgoCD refresh
kubectl patch app k8test-dev -n argocd -p '{"metadata":{"annotations":{"argocd.argoproj.io/refresh":"hard"}}}' --type merge

# Check logs
kubectl logs -n dev deployment/k8test-dev -f

# Run health check
./health-check.bat
```

## 📚 Documentation Priority

1. **Start here**: [CHEAT-SHEET.md](CHEAT-SHEET.md) - Daily commands
2. **Troubleshooting**: [OPERATIONS.md](OPERATIONS.md) - When things break  
3. **Architecture**: [README.md](README.md) - Understanding the system
4. **Setup**: [az-setup.bat](az-setup.bat) & [scaffold-k8test.bat](scaffold-k8test.bat) - Initial setup

---

💡 **Tip**: Keep [CHEAT-SHEET.md](CHEAT-SHEET.md) bookmarked - it has everything you need for day-to-day operations!