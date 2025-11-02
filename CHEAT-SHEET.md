# K8 Test - Quick Reference Cheat Sheet 📋

## 🚀 Quick Start Commands

```bash
# Start ArgoCD UI
kubectl port-forward svc/argocd-server -n argocd 8888:443
# Access: https://localhost:8888 (admin/password from argocd-password.txt)

# Start Application  
kubectl port-forward -n dev deployment/k8test-dev 3000:3000
# Access: http://localhost:3000

# Check Everything
kubectl get applications -n argocd && kubectl get pods -n dev
```

## 🔍 Essential Checks

| What | Command |
|------|---------|
| **App Status** | `kubectl get applications -n argocd` |
| **Pod Status** | `kubectl get pods -n dev` |
| **App Logs** | `kubectl logs -n dev deployment/k8test-dev -f` |
| **ArgoCD Sync** | `kubectl describe application k8test-dev -n argocd` |
| **Current Version** | `kubectl get deployment k8test-dev -n dev -o jsonpath='{.spec.template.spec.containers[0].image}'` |

## 🔧 Quick Fixes

| Problem | Solution |
|---------|----------|
| **ArgoCD Not Syncing** | `kubectl patch app k8test-dev -n argocd -p '{"metadata":{"annotations":{"argocd.argoproj.io/refresh":"hard"}}}' --type merge` |
| **Pod Not Starting** | `kubectl get events -n dev --sort-by='.metadata.creationTimestamp'` |
| **Port Forward Failed** | `taskkill /f /im kubectl.exe` then retry |
| **ArgoCD Stuck** | `kubectl rollout restart statefulset/argocd-application-controller -n argocd` |

## 🌐 Access URLs

| Service | Local URL | Command |
|---------|-----------|---------|
| **ArgoCD UI** | https://localhost:8888 | `kubectl port-forward svc/argocd-server -n argocd 8888:443` |
| **K8 Test App** | http://localhost:3000 | `kubectl port-forward -n dev deployment/k8test-dev 3000:3000` |
| **Health Check** | http://localhost:3000/health | (after port-forward) |
| **API Info** | http://localhost:3000/api/info | (after port-forward) |

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