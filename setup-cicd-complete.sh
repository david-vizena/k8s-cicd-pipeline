#!/bin/bash

# David Vizena - Complete CI/CD Setup Script
# GitHub → GoCD → ArgoCD → Kubernetes Pipeline

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
CLUSTER_NAME="david-vizena-freetier-cluster"
REGION="us-west-2"
NAMESPACE="david-vizena"
GITHUB_REPO="davidvizena/k8s-ci-cd"
GITHUB_BRANCH="k8s-ci-cd-project"

echo -e "${BLUE}🚀 Complete CI/CD Pipeline Setup${NC}"
echo -e "${PURPLE}GitHub → GoCD → ArgoCD → Kubernetes${NC}"
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

print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

# Check prerequisites
check_prerequisites() {
    echo -e "${BLUE}📋 Checking prerequisites...${NC}"
    
    local missing_tools=()
    
    if ! command -v kubectl &> /dev/null; then
        missing_tools+=("kubectl")
    fi
    
    if ! command -v aws &> /dev/null; then
        missing_tools+=("aws")
    fi
    
    if ! command -v eksctl &> /dev/null; then
        missing_tools+=("eksctl")
    fi
    
    if ! command -v helm &> /dev/null; then
        missing_tools+=("helm")
    fi
    
    if ! command -v docker &> /dev/null; then
        missing_tools+=("docker")
    fi
    
    if [ ${#missing_tools[@]} -ne 0 ]; then
        print_error "Missing required tools: ${missing_tools[*]}"
        echo "Please install the missing tools and try again."
        exit 1
    fi
    
    print_status "All prerequisites are installed"
}

# Setup AWS EKS cluster
setup_eks_cluster() {
    echo -e "${BLUE}🏗️  Setting up EKS cluster...${NC}"
    
    if eksctl get cluster $CLUSTER_NAME --region $REGION &> /dev/null; then
        print_warning "Cluster $CLUSTER_NAME already exists"
    else
        eksctl create cluster -f aws/eks-cluster-freetier.yaml
        print_status "EKS cluster created successfully"
    fi
    
    # Update kubeconfig
    aws eks update-kubeconfig --region $REGION --name $CLUSTER_NAME
    print_status "Kubeconfig updated"
}

# Install ArgoCD
install_argocd() {
    echo -e "${BLUE}🔄 Installing ArgoCD...${NC}"
    
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

# Install GoCD
install_gocd() {
    echo -e "${BLUE}🎯 Installing GoCD...${NC}"
    
    # Create namespace
    kubectl create namespace gocd --dry-run=client -o yaml | kubectl apply -f -
    
    # Install GoCD
    kubectl apply -f gocd/gocd-server.yaml
    
    # Wait for GoCD to be ready
    kubectl wait --for=condition=available --timeout=300s deployment/gocd-server -n gocd
    kubectl wait --for=condition=available --timeout=300s deployment/gocd-agent -n gocd
    
    print_status "GoCD installed successfully"
}

# Setup GitHub webhook
setup_github_webhook() {
    echo -e "${BLUE}🔗 Setting up GitHub webhook...${NC}"
    
    # Get GoCD server URL
    GOCD_URL=$(kubectl get svc gocd-server -n gocd -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
    if [ -z "$GOCD_URL" ]; then
        GOCD_URL="localhost:8153"
        print_warning "GoCD will be accessible via port-forward: kubectl port-forward svc/gocd-server -n gocd 8153:8153"
    fi
    
    print_info "GoCD Webhook URL: http://$GOCD_URL/go/api/webhooks/github/notify"
    
    echo -e "${YELLOW}📝 Manual GitHub Webhook Setup Required:${NC}"
    echo "1. Go to your GitHub repository: https://github.com/$GITHUB_REPO"
    echo "2. Go to Settings → Webhooks → Add webhook"
    echo "3. Payload URL: http://$GOCD_URL/go/api/webhooks/github/notify"
    echo "4. Content type: application/json"
    echo "5. Events: Just the push event"
    echo "6. Active: ✓"
    echo ""
    echo "Press Enter when webhook is configured..."
    read -r
}

# Deploy application
deploy_application() {
    echo -e "${BLUE}🚀 Deploying application...${NC}"
    
    # Create namespaces
    kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -
    kubectl create namespace $NAMESPACE-staging --dry-run=client -o yaml | kubectl apply -f -
    
    # Apply Kubernetes manifests
    kubectl apply -f k8s/ -n $NAMESPACE
    kubectl apply -f k8s/ -n $NAMESPACE-staging
    
    # Apply ArgoCD applications
    kubectl apply -f argocd/ -n argocd
    
    print_status "Application deployed successfully"
}

# Setup monitoring
setup_monitoring() {
    echo -e "${BLUE}📈 Setting up monitoring...${NC}"
    
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
    
    print_status "Monitoring stack installed"
}

# Get service URLs
get_urls() {
    echo -e "${BLUE}🌐 Getting service URLs...${NC}"
    
    # Get ArgoCD URL
    ARGOCD_URL=$(kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
    if [ -z "$ARGOCD_URL" ]; then
        ARGOCD_URL="localhost:8080"
        print_warning "ArgoCD port-forward: kubectl port-forward svc/argocd-server -n argocd 8080:443"
    fi
    
    # Get GoCD URL
    GOCD_URL=$(kubectl get svc gocd-server -n gocd -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
    if [ -z "$GOCD_URL" ]; then
        GOCD_URL="localhost:8153"
        print_warning "GoCD port-forward: kubectl port-forward svc/gocd-server -n gocd 8153:8153"
    fi
    
    # Get application URL
    APP_URL=$(kubectl get ingress david-vizena-ingress -n $NAMESPACE -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
    if [ -z "$APP_URL" ]; then
        APP_URL="localhost:3000"
        print_warning "Application port-forward: kubectl port-forward svc/david-vizena-service -n $NAMESPACE 3000:80"
    fi
    
    # Get Grafana URL
    GRAFANA_URL=$(kubectl get svc prometheus-grafana -n monitoring -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
    if [ -z "$GRAFANA_URL" ]; then
        GRAFANA_URL="localhost:3001"
        print_warning "Grafana port-forward: kubectl port-forward svc/prometheus-grafana -n monitoring 3001:80"
    fi
    
    echo ""
    echo -e "${GREEN}🎉 Complete CI/CD Pipeline Setup Complete!${NC}"
    echo "=============================================="
    echo -e "${BLUE}ArgoCD URL:${NC} https://$ARGOCD_URL"
    echo -e "${BLUE}GoCD URL:${NC} http://$GOCD_URL"
    echo -e "${BLUE}Application URL:${NC} https://$APP_URL"
    echo -e "${BLUE}Grafana URL:${NC} http://$GRAFANA_URL"
    echo ""
    echo -e "${BLUE}Credentials:${NC}"
    echo -e "${BLUE}ArgoCD Username:${NC} admin"
    echo -e "${BLUE}ArgoCD Password:${NC} $ARGOCD_PASSWORD"
    echo -e "${BLUE}GoCD Username:${NC} admin"
    echo -e "${BLUE}GoCD Password:${NC} admin"
    echo -e "${BLUE}Grafana Username:${NC} admin"
    echo -e "${BLUE}Grafana Password:${NC} admin123"
    echo ""
    echo -e "${YELLOW}🔄 CI/CD Pipeline Flow:${NC}"
    echo "1. Push code to GitHub → $GITHUB_BRANCH branch"
    echo "2. GitHub webhook triggers GoCD pipeline"
    echo "3. GoCD builds, tests, and deploys to staging"
    echo "4. ArgoCD syncs desired state to Kubernetes"
    echo "5. Application is deployed to production"
    echo ""
    echo -e "${YELLOW}📝 Next Steps:${NC}"
    echo "1. Configure GitHub webhook (see instructions above)"
    echo "2. Test the pipeline by pushing a change"
    echo "3. Monitor deployments in GoCD and ArgoCD"
    echo "4. Set up domain DNS if needed"
}

# Main execution
main() {
    check_prerequisites
    setup_eks_cluster
    install_argocd
    install_gocd
    setup_github_webhook
    deploy_application
    setup_monitoring
    get_urls
}

# Run main function
main "$@"
