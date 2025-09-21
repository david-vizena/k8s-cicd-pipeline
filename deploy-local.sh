#!/bin/bash

# David Vizena - Local CI/CD Development Setup (100% Free)
# This script sets up a local development environment using minikube

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${BLUE}🏠 Starting Local CI/CD Development Setup${NC}"
echo -e "${PURPLE}💰 100% FREE - No cloud costs!${NC}"
echo "=============================================="

# Function to print status
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check prerequisites
check_prerequisites() {
    echo -e "${BLUE}📋 Checking prerequisites...${NC}"
    
    if ! command -v kubectl &> /dev/null; then
        print_error "kubectl is not installed"
        echo "Install with: brew install kubectl"
        exit 1
    fi
    
    if ! command -v minikube &> /dev/null; then
        print_error "minikube is not installed"
        echo "Install with: brew install minikube"
        exit 1
    fi
    
    if ! command -v helm &> /dev/null; then
        print_error "Helm is not installed"
        echo "Install with: brew install helm"
        exit 1
    fi
    
    print_status "All prerequisites are installed"
}

# Start minikube
start_minikube() {
    echo -e "${BLUE}🚀 Starting minikube...${NC}"
    
    if minikube status &> /dev/null; then
        print_warning "Minikube is already running"
    else
        minikube start --memory=4096 --cpus=2 --driver=docker
        print_status "Minikube started successfully"
    fi
    
    # Enable addons
    minikube addons enable ingress
    minikube addons enable metrics-server
    print_status "Minikube addons enabled"
}

# Install ArgoCD locally
install_argocd_local() {
    echo -e "${BLUE}🔄 Installing ArgoCD locally...${NC}"
    
    # Create namespace
    kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
    
    # Install ArgoCD
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    
    # Wait for ArgoCD to be ready
    kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd
    
    print_status "ArgoCD installed successfully"
    
    # Get ArgoCD admin password
    ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
    echo -e "${YELLOW}ArgoCD Admin Password: $ARGOCD_PASSWORD${NC}"
}

# Deploy application locally
deploy_application_local() {
    echo -e "${BLUE}🚀 Deploying application locally...${NC}"
    
    # Create namespace
    kubectl create namespace david-vizena --dry-run=client -o yaml | kubectl apply -f -
    
    # Build and load image into minikube
    eval $(minikube docker-env)
    docker build -t davidvizena/hello-world:local .
    
    # Update deployment to use local image
    sed 's|image: ghcr.io/davidvizena/k8s-ci-cd:latest|image: davidvizena/hello-world:local|g' k8s/deployment.yaml | kubectl apply -f - -n david-vizena
    
    # Apply other manifests
    kubectl apply -f k8s/namespace.yaml -n david-vizena
    kubectl apply -f k8s/service.yaml -n david-vizena
    kubectl apply -f k8s/network-policy.yaml -n david-vizena
    
    print_status "Application deployed successfully"
}

# Setup local monitoring
setup_local_monitoring() {
    echo -e "${BLUE}📈 Setting up local monitoring...${NC}"
    
    # Install Prometheus and Grafana using Helm
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo update
    
    # Install Prometheus
    helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
        --namespace monitoring \
        --create-namespace \
        --set grafana.adminPassword=admin123 \
        --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false \
        --set prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues=false
    
    print_status "Local monitoring stack installed"
}

# Get local URLs
get_local_urls() {
    echo -e "${BLUE}🌐 Getting local service URLs...${NC}"
    
    # Get minikube IP
    MINIKUBE_IP=$(minikube ip)
    
    # Get ArgoCD URL
    ARGOCD_PORT=$(kubectl get svc argocd-server -n argocd -o jsonpath='{.spec.ports[0].nodePort}')
    ARGOCD_URL="$MINIKUBE_IP:$ARGOCD_PORT"
    
    # Get application URL
    APP_PORT=$(kubectl get svc david-vizena-service -n david-vizena -o jsonpath='{.spec.ports[0].nodePort}')
    APP_URL="$MINIKUBE_IP:$APP_PORT"
    
    # Get Grafana URL
    GRAFANA_PORT=$(kubectl get svc prometheus-grafana -n monitoring -o jsonpath='{.spec.ports[0].nodePort}')
    GRAFANA_URL="$MINIKUBE_IP:$GRAFANA_PORT"
    
    echo ""
    echo -e "${GREEN}🎉 Local Development Setup Complete!${NC}"
    echo "======================================"
    echo -e "${BLUE}ArgoCD URL:${NC} http://$ARGOCD_URL"
    echo -e "${BLUE}Application URL:${NC} http://$APP_URL"
    echo -e "${BLUE}Grafana URL:${NC} http://$GRAFANA_URL"
    echo -e "${BLUE}ArgoCD Username:${NC} admin"
    echo -e "${BLUE}ArgoCD Password:${NC} $ARGOCD_PASSWORD"
    echo -e "${BLUE}Grafana Username:${NC} admin"
    echo -e "${BLUE}Grafana Password:${NC} admin123"
    echo ""
    echo -e "${YELLOW}Local Development Benefits:${NC}"
    echo "✅ No cloud costs"
    echo "✅ Fast development cycle"
    echo "✅ Full CI/CD pipeline locally"
    echo "✅ Easy debugging"
    echo ""
    echo -e "${YELLOW}Next Steps:${NC}"
    echo "1. Access ArgoCD and sync your application"
    echo "2. Test the CI/CD pipeline locally"
    echo "3. Develop and iterate quickly"
    echo "4. When ready, deploy to cloud for production"
}

# Main execution
main() {
    check_prerequisites
    start_minikube
    install_argocd_local
    deploy_application_local
    setup_local_monitoring
    get_local_urls
}

# Run main function
main "$@"
