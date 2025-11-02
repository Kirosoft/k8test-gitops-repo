@echo off
rem ===================================================================
rem K8 Test - Health Check Script
rem Run this anytime to check the status of your K8 Test deployment
rem ===================================================================

echo 🔍 K8 Test Health Check
echo =======================
echo.

echo 1. Checking ArgoCD Applications...
kubectl get applications -n argocd 2>nul
if %errorlevel% neq 0 (
    echo ❌ Cannot connect to cluster. Is kubectl configured?
    pause
    exit /b 1
)

echo.
echo 2. Checking Application Pods...
kubectl get pods -n dev 2>nul
if %errorlevel% neq 0 (
    echo ⚠️  No pods found in dev namespace
) else (
    echo ✅ Pods found in dev namespace
)

echo.
echo 3. Checking ArgoCD Pods...
kubectl get pods -n argocd 2>nul | find "Running" >nul
if %errorlevel% neq 0 (
    echo ⚠️  ArgoCD pods may not be running properly
) else (
    echo ✅ ArgoCD pods are running
)

echo.
echo 4. Current Application Image...
for /f "tokens=*" %%i in ('kubectl get deployment k8test-dev -n dev -o jsonpath^="{.spec.template.spec.containers[0].image}" 2^>nul') do (
    echo Image: %%i
)

echo.
echo 5. Application Service Status...
kubectl get svc -n dev 2>nul

echo.
echo 6. Recent Events...
kubectl get events -n dev --sort-by='.metadata.creationTimestamp' | tail -n 5 2>nul

echo.
echo ===================================================================
echo 🚀 Quick Access Commands:
echo   ArgoCD UI:  kubectl port-forward svc/argocd-server -n argocd 8888:443
echo   App URL:    kubectl port-forward -n dev deployment/k8test-dev 3000:3000  
echo   Live Logs:  kubectl logs -n dev deployment/k8test-dev -f
echo ===================================================================
echo.

pause