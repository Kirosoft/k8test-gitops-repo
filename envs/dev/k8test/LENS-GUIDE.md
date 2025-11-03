# Kubernetes Lens Installation Guide 🖥️

Kubernetes Lens provides a powerful GUI for managing and monitoring your Kubernetes clusters. Here are several installation options:

## 🚀 Installation Options

### Option 1: Direct Download (Recommended)
1. Visit: https://k8slens.dev/
2. Download the Windows installer
3. Run the installer and follow the setup wizard

### Option 2: Winget (Windows Package Manager)
```bash
# Official Lens (requires registration)
winget install Mirantis.Lens

# Alternative: OpenLens (free, open-source fork)
winget install MuhammedKalkan.OpenLens

# Alternative: FreeLens (community version)
winget install Freelensapp.Freelens
```

### Option 3: Chocolatey
```bash
# Install Chocolatey first if needed: https://chocolatey.org/install
choco install lens
```

## ⚙️ Initial Setup

### 1. Add Your Cluster
After installation, Lens will automatically detect your kubectl context:

1. **Launch Lens**
2. **Add Cluster** → It should auto-detect your AKS cluster
3. **Connect** → Uses your existing kubectl credentials

### 2. Verify Connection
- Navigate to **Workloads** → **Pods**
- You should see pods from both `argocd` and `dev` namespaces

## 🎯 Lens for K8 Test Operations

### Essential Views for Our Setup

#### 1. **Applications (ArgoCD)**
- **Path**: Custom Resources → Applications (argoproj.io/v1alpha1)
- **What to check**: Sync status, health status of k8test applications
- **Quick access**: Filter by namespace `argocd`

#### 2. **Deployments (App Pods)**  
- **Path**: Workloads → Deployments
- **What to check**: k8test-dev deployment status
- **Quick access**: Filter by namespace `dev`

#### 3. **Pods (Running Instances)**
- **Path**: Workloads → Pods  
- **What to check**: Pod status, resource usage, logs
- **Quick access**: Filter by namespace `dev` or `argocd`

#### 4. **Services & Ingress**
- **Path**: Network → Services / Ingresses
- **What to check**: Service endpoints, ingress routing
- **Quick access**: Filter by namespace `dev`

#### 5. **Events (Troubleshooting)**
- **Path**: Cluster → Events
- **What to check**: Recent cluster events, error messages
- **Quick access**: Sort by timestamp, filter by namespace

## 📊 Key Lens Features for K8 Test

### Real-time Monitoring
```
✅ Pod CPU/Memory usage graphs
✅ Live log streaming with color coding
✅ Real-time event monitoring  
✅ Resource health status indicators
```

### Quick Actions
```
🔄 Restart deployments with one click
📝 Edit YAML configurations inline
🔍 Search across all resources
📊 View detailed resource metrics
```

### Debugging Tools
```
🐛 Interactive pod shell access
📋 Copy pod/service details
🔗 Port-forwarding GUI setup
📁 Download pod logs
```

## 🎛️ Lens Dashboard Setup for K8 Test

### 1. Create Custom Dashboard
1. **Dashboard** → **Add Chart**
2. **Select metrics** for k8test-dev deployment
3. **Add ArgoCD application status widgets**

### 2. Bookmark Important Views
- **ArgoCD Applications**: Custom Resources → Applications
- **K8 Test Pods**: Workloads → Pods (dev namespace)
- **Cluster Events**: Cluster → Events

### 3. Set Up Notifications
- **Preferences** → **Notifications** 
- **Enable alerts** for pod failures, OOMKilled events

## 🔧 Lens vs Command Line

| Task | Command Line | Lens GUI |
|------|-------------|----------|
| **View pod status** | `kubectl get pods -n dev` | Workloads → Pods (visual status) |
| **Check logs** | `kubectl logs -f pod-name` | Click pod → Logs tab (live stream) |
| **Port forward** | `kubectl port-forward svc/...` | Network → Services → Port Forward button |
| **Edit config** | `kubectl edit deployment/...` | Right-click deployment → Edit |
| **View events** | `kubectl get events --sort-by=...` | Cluster → Events (real-time) |

## 📋 Lens Cheat Sheet for K8 Test

### Quick Navigation
```
Ctrl+K          - Command palette (search everything)
Ctrl+Shift+C    - Open terminal in Lens
Ctrl+R          - Refresh current view
F5              - Refresh resource data
```

### Essential Bookmarks
1. **Applications**: Custom Resources → Applications (argocd namespace)
2. **App Pods**: Workloads → Pods (dev namespace)  
3. **ArgoCD Pods**: Workloads → Pods (argocd namespace)
4. **Services**: Network → Services (dev namespace)
5. **Events**: Cluster → Events

### Pro Tips
- **Multi-select pods** to view logs from multiple containers
- **Use filters** heavily - save time by filtering by namespace/labels
- **Pin important resources** to keep them in quick access
- **Use the terminal** built into Lens for kubectl commands

## 🆘 Troubleshooting Lens

### Connection Issues
```bash
# Verify kubectl works
kubectl cluster-info

# Check current context  
kubectl config current-context

# If Lens can't connect, refresh cluster in Lens settings
```

### Performance Issues
- **Disable unused extensions** in Preferences → Extensions
- **Limit resource watches** in cluster settings
- **Close unused tabs** to reduce memory usage

---

💡 **Pro Tip**: Keep Lens open alongside your terminal - use Lens for monitoring and GUI operations, terminal for quick commands and scripting!