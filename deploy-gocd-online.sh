#!/bin/bash

# Deploy GoCD to your Kubernetes cluster for online access
# This will make GoCD accessible from anywhere, not just locally

set -e

echo "🌐 Deploying GoCD Online to Kubernetes..."
echo "========================================"

# Stop local GoCD first
echo "🛑 Stopping local GoCD..."
docker stop gocd-server gocd-agent 2>/dev/null || true
docker rm gocd-server gocd-agent 2>/dev/null || true

# Deploy GoCD to Kubernetes
echo "🚀 Deploying GoCD to Kubernetes..."
kubectl apply -f gocd/gocd-server.yaml

# Wait for GoCD to be ready
echo "⏳ Waiting for GoCD to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/gocd-server -n gocd

# Get the external IP
echo "🌐 Getting external access..."
EXTERNAL_IP=$(kubectl get svc gocd-server -n gocd -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

if [ -z "$EXTERNAL_IP" ]; then
    echo "⚠️  LoadBalancer not ready yet. Setting up port-forward..."
    echo "🔗 GoCD will be accessible at: http://localhost:8153"
    echo "📝 Run this command to access: kubectl port-forward svc/gocd-server -n gocd 8153:8153"
else
    echo "✅ GoCD is accessible at: http://$EXTERNAL_IP:8153"
fi

echo ""
echo "🎯 GoCD Online Setup Complete!"
echo "=============================="
echo "🌐 Access GoCD at: http://$EXTERNAL_IP:8153 (or localhost:8153)"
echo "👤 Username: admin"
echo "🔑 Password: admin"
echo ""
echo "📝 Next steps:"
echo "1. Access GoCD in your browser"
echo "2. Create the same pipeline you're creating locally"
echo "3. Test it works online"
echo "4. Share the URL with employers!"
