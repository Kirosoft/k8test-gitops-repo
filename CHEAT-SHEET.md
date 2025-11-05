# K8 Test - Quick Reference Cheat Sheet 📋

## 🚀 Quick Start Commands

```bash
# ⚠️ ALWAYS CHECK CLUSTER CONTEXT FIRST
kubectl config current-context  # Should show: idp-aks-cluster

# Start ArgoCD UI (Production Cluster)
kubectl port-forward svc/argocd-server -n argocd 8888:443
# Access: https://localhost:8888 (admin/password from argocd-password.txt)

# Start Application (Production Cluster)
kubectl port-forward -n dev deployment/k8test-dev 3000:3000
# Access: http://localhost:3000

# Check Everything (Production Cluster)
kubectl get applications -n argocd && kubectl get pods -n dev
```

## 🔍 Essential Checks

| What | Command | Lens GUI |
|------|---------|----------|
| **Current Cluster** | `kubectl config current-context` | Check cluster name in sidebar |
| **App Status** | `kubectl get applications -n argocd` | Custom Resources → Applications |
| **Pod Status** | `kubectl get pods -n dev` | Workloads → Pods (dev namespace) |
| **App Logs** | `kubectl logs -n dev deployment/k8test-dev -f` | Click pod → Logs tab |
| **ArgoCD Sync** | `kubectl describe application k8test-dev -n argocd` | Click application → Details |
| **Current Version** | `kubectl get deployment k8test-dev -n dev -o jsonpath='{.spec.template.spec.containers[0].image}'` | Workloads → Deployments → k8test-dev |

## 🔧 Quick Fixes

| Problem | Solution |
|---------|----------|
| **Wrong Cluster** | `kubectl config use-context idp-aks-cluster` |
| **ArgoCD Not Syncing** | `kubectl patch app k8test-dev -n argocd -p '{"metadata":{"annotations":{"argocd.argoproj.io/refresh":"hard"}}}' --type merge` |
| **Pod Not Starting** | `kubectl get events -n dev --sort-by='.metadata.creationTimestamp'` |
| **Port Forward Failed** | `taskkill /f /im kubectl.exe` then retry |
| **ArgoCD Stuck** | `kubectl rollout restart statefulset/argocd-application-controller -n argocd` |

## 🌐 Cluster Management

| Task | Command |
|------|---------|
| **Check Current Cluster** | `kubectl config current-context` |
| **Switch to Production** | `kubectl config use-context idp-aks-cluster` |
| **List All Contexts** | `kubectl config get-contexts` |
| **Cluster Info** | `kubectl cluster-info` |

## 🌐 Access URLs

| Service | Local URL | Command | Lens Alternative |
|---------|-----------|---------|------------------|
| **ArgoCD UI** | https://localhost:8888 | `kubectl port-forward svc/argocd-server -n argocd 8888:443` | Network → Services → argocd-server → Port Forward |
| **K8 Test App** | http://localhost:3000 | `kubectl port-forward -n dev deployment/k8test-dev 3000:3000` | Network → Services → k8test-dev → Port Forward |
| **Kubernetes Lens** | Native GUI | Install from https://k8slens.dev/ | Best for visual cluster management |
| **Health Check** | http://localhost:3000/health | (after port-forward) | - |
| **API Info** | http://localhost:3000/api/info | (after port-forward) | - |

## 📊 Status Colors

| Status | Meaning |
|--------|---------|
| 🟢 **Synced + Healthy** | All good! |
| 🟡 **Synced + Progressing** | Deployment in progress |
| 🔴 **OutOfSync** | Need to sync |
| ⚪ **Unknown** | Not deployed yet |

## 🔄 Common Workflows

### Deploy New Version
1. Push code to `main` branch
2. GitHub Actions builds & pushes image
3. Updates GitOps repo automatically  
4. ArgoCD syncs new version
5. Check: `kubectl get applications -n argocd`

### Force Refresh ArgoCD
```bash
kubectl patch app k8test-dev -n argocd -p '{"metadata":{"annotations":{"argocd.argoproj.io/refresh":"hard"}}}' --type merge
```

### View Live Logs
```bash
kubectl logs -n dev deployment/k8test-dev -f
```

### Get ArgoCD Password
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### Test App Inside Pod
```bash
POD=$(kubectl get pods -n dev -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n dev $POD -- node -e "console.log('Testing...'); require('http').get('http://localhost:3000/', res => res.on('data', d => console.log(d.toString())));"
```

## 🆘 Emergency Numbers

| Issue | Quick Check | Emergency Fix |
|-------|-------------|---------------|
| **App Down** | `kubectl get pods -n dev` | `kubectl rollout restart deployment/k8test-dev -n dev` |
| **ArgoCD Down** | `kubectl get pods -n argocd` | `kubectl rollout restart deployment/argocd-server -n argocd` |
| **Sync Stuck** | `kubectl get applications -n argocd` | Delete & recreate app (root app will auto-restore) |

## 📱 One-Liner Health Check
```bash
echo "Apps: $(kubectl get applications -n argocd --no-headers | wc -l) | Pods: $(kubectl get pods -n dev --no-headers | grep Running | wc -l)/$(kubectl get pods -n dev --no-headers | wc -l) | ArgoCD: $(kubectl get pods -n argocd --no-headers | grep Running | wc -l)/$(kubectl get pods -n argocd --no-headers | wc -l)"
```

---
💡 **Pro Tip**: Bookmark this cheat sheet and keep it open during development!


## argo cd password:
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" |
  ForEach-Object { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }


# scale the node pool
az aks nodepool scale --name nodepool1 --cluster-name idp-aks-cluster --resource-group rg-idp  --node-count 0