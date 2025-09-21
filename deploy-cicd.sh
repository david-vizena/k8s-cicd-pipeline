#!/bin/bash

# David Vizena - CI/CD Pipeline Deployment Script (100% Free-Tier Compatible)
# This script sets up the complete CI/CD infrastructure without any costs

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Configuration
CLUSTER_NAME="david-vizena-freetier-cluster"
REGION="us-west-2"
NAMESPACE="david-vizena"
GITHUB_REPO="davidvizena/k8s-ci-cd"
FREETIER_MODE=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --freetier)
      FREETIER_MODE=true
      CLUSTER_NAME="david-vizena-freetier-cluster"
      shift
      ;;
    --help)
      echo "Usage: $0 [--freetier] [--help]"
      echo "  --freetier: Use free-tier optimized configuration"
      echo "  --help: Show this help message"
      exit 0
      ;;
    *)
      echo "Unknown option $1"
      exit 1
      ;;
  esac
done

echo -e "${BLUE}🚀 Starting CI/CD Pipeline Deployment${NC}"
if [ "$FREETIER_MODE" = true ]; then
    echo -e "${PURPLE}💰 FREE-TIER MODE: Optimized for zero costs${NC}"
    echo -e "${YELLOW}⚠️  Using t3.micro instances and minimal resources${NC}"
fi
echo "=================================="

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
        exit 1
    fi
    
    if ! command -v aws &> /dev/null; then
        print_error "AWS CLI is not installed"
        exit 1
    fi
    
    if ! command -v eksctl &> /dev/null; then
        print_error "eksctl is not installed"
        exit 1
    fi
    
    if ! command -v helm &> /dev/null; then
        print_error "Helm is not installed"
        exit 1
    fi
    
    print_status "All prerequisites are installed"
}

# Create EKS cluster
create_eks_cluster() {
    echo -e "${BLUE}🏗️  Creating EKS cluster...${NC}"
    
    if [ "$FREETIER_MODE" = true ]; then
        print_warning "Using FREE-TIER configuration (t3.micro instances, minimal resources)"
        CLUSTER_CONFIG="aws/eks-cluster-freetier.yaml"
    else
        print_warning "Using standard configuration (t3.micro instances)"
        CLUSTER_CONFIG="aws/eks-cluster.yaml"
    fi
    
    if eksctl get cluster $CLUSTER_NAME --region $REGION &> /dev/null; then
        print_warning "Cluster $CLUSTER_NAME already exists"
    else
        eksctl create cluster -f $CLUSTER_CONFIG
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

# Install OpenSearch Operator
install_opensearch() {
    echo -e "${BLUE}📊 Installing OpenSearch...${NC}"
    
    # Install OpenSearch Operator
    kubectl apply -f https://opensearch.org/downloads/opensearch-operator/opensearch-operator-2.3.0.yaml
    
    # Wait for operator to be ready
    kubectl wait --for=condition=available --timeout=300s deployment/opensearch-operator-controller-manager -n opensearch-operator-system
    
    print_status "OpenSearch operator installed"
}

# Deploy application
deploy_application() {
    echo -e "${BLUE}🚀 Deploying application...${NC}"
    
    # Create namespace
    kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -
    
    # Apply Kubernetes manifests
    kubectl apply -f k8s/ -n $NAMESPACE
    
    # Apply OpenSearch configuration
    kubectl apply -f opensearch/ -n $NAMESPACE
    
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

# Setup cost monitoring
setup_cost_monitoring() {
    echo -e "${BLUE}💰 Setting up cost monitoring...${NC}"
    
    # Create cost monitoring script
    cat > monitor-costs.sh << 'EOF'
#!/bin/bash
echo "🔍 Checking AWS Free Tier Usage..."
echo "=================================="

# Check EC2 usage
echo "📊 EC2 Instances:"
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name]' --output table

# Check EBS usage
echo "💾 EBS Volumes:"
aws ec2 describe-volumes --query 'Volumes[*].[VolumeId,Size,VolumeType,State]' --output table

# Check EKS cluster
echo "☸️  EKS Clusters:"
aws eks list-clusters --output table

echo ""
echo "💡 Cost Optimization Tips:"
echo "- Use t3.micro instances only"
echo "- Keep storage under 30GB total"
echo "- Monitor usage weekly"
echo "- Set up billing alerts"
EOF
    
    chmod +x monitor-costs.sh
    print_status "Cost monitoring script created: ./monitor-costs.sh"
    
    # Set up billing alert (if possible)
    echo -e "${YELLOW}⚠️  Remember to set up billing alerts in AWS Console${NC}"
    echo -e "${YELLOW}   Go to: AWS Console → Billing → Budgets → Create Budget${NC}"
}

# Get service URLs
get_urls() {
    echo -e "${BLUE}🌐 Getting service URLs...${NC}"
    
    # Get ArgoCD URL
    ARGOCD_URL=$(kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
    if [ -z "$ARGOCD_URL" ]; then
        ARGOCD_URL="localhost:8080"
        kubectl port-forward svc/argocd-server -n argocd 8080:443 &
        print_warning "ArgoCD port-forwarded to localhost:8080"
    fi
    
    # Get application URL
    APP_URL=$(kubectl get ingress david-vizena-ingress -n $NAMESPACE -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
    if [ -z "$APP_URL" ]; then
        APP_URL="localhost:3000"
        kubectl port-forward svc/david-vizena-service -n $NAMESPACE 3000:80 &
        print_warning "Application port-forwarded to localhost:3000"
    fi
    
    echo ""
    echo -e "${GREEN}🎉 Deployment Complete!${NC}"
    echo "================================"
    echo -e "${BLUE}ArgoCD URL:${NC} https://$ARGOCD_URL"
    echo -e "${BLUE}Application URL:${NC} https://$APP_URL"
    echo -e "${BLUE}ArgoCD Username:${NC} admin"
    echo -e "${BLUE}ArgoCD Password:${NC} $ARGOCD_PASSWORD"
    echo ""
    echo -e "${YELLOW}Next Steps:${NC}"
    echo "1. Configure your domain DNS to point to the load balancer"
    echo "2. Update SSL certificate ARN in k8s/ingress.yaml"
    echo "3. Set up GitHub repository secrets for CI/CD"
    echo "4. Push code to trigger the pipeline"
}

# Main execution
main() {
    check_prerequisites
    create_eks_cluster
    install_argocd
    install_opensearch
    deploy_application
    setup_monitoring
    setup_cost_monitoring
    get_urls
}

# Run main function
main "$@"
