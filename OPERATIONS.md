# K8 Test - Operations Guide 🛠️

This guide contains all the essential commands and checks for operating the K8 Test application with ArgoCD GitOps.

## 🔍 Basic Status Checks

### Check All Applications
```bash
# View all ArgoCD applications
kubectl get applications -n argocd

# Expected output:
# NAME             SYNC STATUS   HEALTH STATUS
# k8test-dev       Synced        Healthy
# k8test-prod      Unknown       Healthy  
# k8test-root      Synced        Healthy
# k8test-staging   Unknown       Healthy
```

### Check Pod Status
```bash
# Check pods in dev environment
kubectl get pods -n dev

# Check pod details
kubectl get pods -n dev -o wide

# Check all resources in dev namespace
kubectl get all -n dev

# Expected output should show:
# - k8test-dev pod in Running state
# - k8test-dev service  
# - k8test-dev deployment with 1/1 ready
```

### Check ArgoCD Components
```bash
# Check ArgoCD pods
kubectl get pods -n argocd

# All pods should be Running:
# - argocd-application-controller-0
# - argocd-server-*
# - argocd-repo-server-*
# - argocd-redis-*
# - argocd-dex-server-*
```

## 🌐 Access ArgoCD UI

### Method 1: Port Forward (Recommended)
```bash
# Start ArgoCD UI port-forward (HTTPS)
kubectl port-forward svc/argocd-server -n argocd 8888:443

# Access: https://localhost:8888
# Username: admin
# Password: See steps below to get password
```

### Method 2: HTTP Port Forward
```bash
# Alternative HTTP access
kubectl port-forward svc/argocd-server -n argocd 8080:80

# Access: http://localhost:8080
```

### Get ArgoCD Admin Password
```bash
# Get the admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Or on Windows PowerShell:
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" > temp.txt
certutil -decode temp.txt password.txt
type password.txt
del temp.txt password.txt
```

## 🚀 Application Access

### Access K8 Test Application
```bash
# Port-forward to application
kubectl port-forward -n dev deployment/k8test-dev 3000:3000

# Test endpoints:
# http://localhost:3000          - Main app
# http://localhost:3000/health   - Health check  
# http://localhost:3000/api/info - API information
```

### Test Application Inside Cluster
```bash
# Get pod name
kubectl get pods -n dev

# Test from inside pod
kubectl exec -n dev pod/k8test-dev-<pod-id> -- node -e "
const http = require('http');
http.get('http://127.0.0.1:3000/', (res) => {
  let data = '';
  res.on('data', (chunk) => { data += chunk; });
  res.on('end', () => { console.log(data); });
});"
```

## 🔄 ArgoCD Sync Operations

### Check Sync Status
```bash
# Check application sync status
kubectl describe application k8test-dev -n argocd

# Look for:
# - Sync Status: Synced
# - Health Status: Healthy  
# - Revision: Latest commit SHA
```

### Force Application Refresh
```bash
# Hard refresh application (clears cache)
kubectl patch app k8test-dev -n argocd -p '{"metadata":{"annotations":{"argocd.argoproj.io/refresh":"hard"}}}' --type merge

# Sync application manually
kubectl patch app k8test-dev -n argocd -p '{"operation":{"initiatedBy":{"username":"admin"},"sync":{"revision":"HEAD"}}}' --type merge
```

### Restart ArgoCD Application Controller
```bash
# If ArgoCD gets stuck, restart the controller
kubectl rollout restart statefulset/argocd-application-controller -n argocd

# Wait for restart to complete
kubectl rollout status statefulset/argocd-application-controller -n argocd
```

## 📊 Monitoring and Logs

### View Application Logs
```bash
# Current application logs
kubectl logs -n dev deployment/k8test-dev

# Follow logs in real-time
kubectl logs -n dev deployment/k8test-dev -f

# Previous container logs (if pod crashed)
kubectl logs -n dev deployment/k8test-dev --previous
```

### View ArgoCD Logs
```bash
# Application controller logs (for sync issues)
kubectl logs -n argocd argocd-application-controller-0

# Repository server logs (for git issues)
kubectl logs -n argocd deployment/argocd-repo-server

# ArgoCD server logs (for UI issues)
kubectl logs -n argocd deployment/argocd-server
```

### View Events
```bash
# Kubernetes events in dev namespace
kubectl get events -n dev --sort-by='.metadata.creationTimestamp'

# ArgoCD events
kubectl get events -n argocd --sort-by='.metadata.creationTimestamp'
```

## 🔧 Troubleshooting

### Application Not Starting
```bash
# 1. Check pod status
kubectl get pods -n dev

# 2. Describe pod for events
kubectl describe pod -n dev <pod-name>

# 3. Check pod logs
kubectl logs -n dev <pod-name>

# 4. Check service and ingress
kubectl get svc,ingress -n dev
```

### ArgoCD Not Syncing
```bash
# 1. Check application status
kubectl get application k8test-dev -n argocd -o yaml

# 2. Check repository access
kubectl logs -n argocd deployment/argocd-repo-server | grep -i error

# 3. Force refresh
kubectl patch app k8test-dev -n argocd -p '{"metadata":{"annotations":{"argocd.argoproj.io/refresh":"hard"}}}' --type merge

# 4. Delete and recreate application (last resort)
kubectl delete application k8test-dev -n argocd
# ArgoCD root app will recreate it automatically
```

### Image Pull Issues
```bash
# Check if ACR is properly attached to AKS
az aks check-acr --name idp-aks-cluster --resource-group rg-idp --acr k8demoacr

# Attach ACR to AKS if needed
az aks update --name idp-aks-cluster --resource-group rg-idp --attach-acr k8demoacr
```

### Port Forward Not Working
```bash
# Check if port is already in use
netstat -an | findstr :8888

# Kill existing kubectl processes
taskkill /f /im kubectl.exe

# Restart port-forward
kubectl port-forward svc/argocd-server -n argocd 8888:443
```

## 🔄 CI/CD Pipeline Status

### Check GitHub Actions
```bash
# View recent workflow runs (requires GitHub CLI)
gh run list --repo kirosoft/k8test-repo --limit 5

# View specific run details
gh run view <run-id> --repo kirosoft/k8test-repo
```

### Verify GitOps Updates
```bash
# Check latest commit in GitOps repo
cd k8test-gitops-repo
git log --oneline -5

# Check if image tag matches latest build
kubectl get application k8test-dev -n argocd -o jsonpath='{.spec.source.helm.parameters[?(@.name=="image.tag")].value}'
```

## 📋 Health Check Checklist

Run this complete health check to verify everything is working:

```bash
echo "🔍 K8 Test Health Check"
echo "======================="

echo "1. ArgoCD Pods:"
kubectl get pods -n argocd | grep -E "(NAME|argocd)"

echo -e "\n2. Application Pods:"
kubectl get pods -n dev

echo -e "\n3. ArgoCD Applications:"
kubectl get applications -n argocd

echo -e "\n4. Application Image:"
kubectl get deployment k8test-dev -n dev -o jsonpath='{.spec.template.spec.containers[0].image}'

echo -e "\n5. Service Status:"
kubectl get svc -n dev

echo -e "\n✅ Health check complete!"
```

## 🚨 Emergency Procedures

### Complete Reset
```bash
# 1. Delete all applications
kubectl delete applications --all -n argocd

# 2. Reapply root application
kubectl apply -f k8test-gitops-repo/root-app.yaml

# 3. Wait for auto-sync
kubectl get applications -n argocd --watch
```

### Rollback Application
```bash
# Find previous revision
kubectl describe application k8test-dev -n argocd | grep -A5 History

# Manually update image tag in GitOps repo to previous version
# Then commit and push - ArgoCD will auto-sync
```

This operations guide covers all the essential day-to-day operations you'll need! 🎯