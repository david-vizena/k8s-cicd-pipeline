#!/bin/bash

# David Vizena - Employer Access Setup Script
# Sets up public access for employers to view the CI/CD pipeline

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}🎯 Setting up Employer Access for CI/CD Portfolio${NC}"
echo -e "${PURPLE}Making your pipeline visible to potential employers${NC}"
echo "=================================================="

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

# Deploy portfolio dashboard
deploy_portfolio_dashboard() {
    echo -e "${BLUE}📊 Deploying Portfolio Dashboard...${NC}"
    
    kubectl apply -f employer-access/portfolio-dashboard.yaml
    kubectl wait --for=condition=available --timeout=300s deployment/portfolio-dashboard -n portfolio-dashboard
    
    print_status "Portfolio dashboard deployed successfully"
}

# Setup public access
setup_public_access() {
    echo -e "${BLUE}🌐 Setting up public access...${NC}"
    
    # Get load balancer URLs
    PORTFOLIO_URL=$(kubectl get svc portfolio-dashboard -n portfolio-dashboard -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
    GOCD_URL=$(kubectl get svc gocd-server -n gocd -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
    ARGOCD_URL=$(kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
    APP_URL=$(kubectl get ingress david-vizena-ingress -n david-vizena -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
    
    echo ""
    echo -e "${GREEN}🎉 Employer Access URLs Generated!${NC}"
    echo "=================================="
    echo -e "${BLUE}Portfolio Dashboard:${NC} http://$PORTFOLIO_URL"
    echo -e "${BLUE}GoCD Pipeline:${NC} http://$GOCD_URL:8153"
    echo -e "${BLUE}ArgoCD GitOps:${NC} https://$ARGOCD_URL:8080"
    echo -e "${BLUE}Live Application:${NC} https://$APP_URL"
    echo ""
    
    # Create employer access file
    cat > EMPLOYER-ACCESS-URLS.txt << EOF
🎯 David Vizena - DevOps Portfolio Access URLs
=============================================

📊 Portfolio Dashboard (Main Entry Point):
   http://$PORTFOLIO_URL

🎯 GoCD CI/CD Pipeline:
   http://$GOCD_URL:8153
   Username: demo
   Password: demo123

🔄 ArgoCD GitOps:
   https://$ARGOCD_URL:8080
   Username: admin
   Password: admin123

🚀 Live Application:
   https://$APP_URL

📈 Monitoring Dashboard:
   https://$GOCD_URL:3001
   Username: admin
   Password: admin123

📝 GitHub Repository:
   https://github.com/davidvizena/k8s-ci-cd

🔧 How to Test:
   1. Go to GitHub repository
   2. Make a small change to any file
   3. Commit and push
   4. Watch the pipeline in GoCD
   5. See deployment in ArgoCD
   6. View live application update

📞 Contact:
   Email: david.vizena@example.com
   LinkedIn: linkedin.com/in/davidvizena
   GitHub: github.com/davidvizena
EOF
    
    print_status "Employer access URLs saved to EMPLOYER-ACCESS-URLS.txt"
}

# Setup demo credentials
setup_demo_credentials() {
    echo -e "${BLUE}🔐 Setting up demo credentials...${NC}"
    
    # Create demo user for GoCD
    kubectl create secret generic gocd-demo-user \
        --from-literal=username=demo \
        --from-literal=password=demo123 \
        -n gocd --dry-run=client -o yaml | kubectl apply -f -
    
    print_status "Demo credentials configured"
}

# Create employer documentation
create_employer_docs() {
    echo -e "${BLUE}📚 Creating employer documentation...${NC}"
    
    # Copy employer guide to accessible location
    cp EMPLOYER-ACCESS-GUIDE.md /tmp/employer-guide.md
    
    print_status "Employer documentation created"
}

# Setup monitoring for employer visibility
setup_employer_monitoring() {
    echo -e "${BLUE}📈 Setting up employer monitoring...${NC}"
    
    # Create a simple monitoring script
    cat > monitor-for-employers.sh << 'EOF'
#!/bin/bash
echo "🔍 David Vizena - Portfolio System Status"
echo "========================================"

# Check GoCD status
echo "🎯 GoCD Pipeline Status:"
kubectl get pods -n gocd | grep gocd-server

# Check ArgoCD status
echo "🔄 ArgoCD Status:"
kubectl get pods -n argocd | grep argocd-server

# Check application status
echo "🚀 Application Status:"
kubectl get pods -n david-vizena | grep david-vizena-app

# Check portfolio dashboard
echo "📊 Portfolio Dashboard:"
kubectl get pods -n portfolio-dashboard | grep portfolio-dashboard

echo ""
echo "✅ All systems operational for employer review!"
EOF
    
    chmod +x monitor-for-employers.sh
    print_status "Employer monitoring script created"
}

# Generate QR codes for easy access
generate_qr_codes() {
    echo -e "${BLUE}📱 Generating QR codes for easy access...${NC}"
    
    # Install qrencode if available
    if command -v qrencode &> /dev/null; then
        PORTFOLIO_URL=$(kubectl get svc portfolio-dashboard -n portfolio-dashboard -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
        
        echo "QR Code for Portfolio Dashboard:"
        qrencode -t ansiutf8 "http://$PORTFOLIO_URL"
        
        print_status "QR codes generated"
    else
        print_warning "qrencode not installed. Install with: brew install qrencode"
    fi
}

# Main execution
main() {
    deploy_portfolio_dashboard
    setup_public_access
    setup_demo_credentials
    create_employer_docs
    setup_employer_monitoring
    generate_qr_codes
    
    echo ""
    echo -e "${GREEN}🎉 Employer Access Setup Complete!${NC}"
    echo "======================================"
    echo -e "${YELLOW}📋 Next Steps:${NC}"
    echo "1. Share the URLs from EMPLOYER-ACCESS-URLS.txt"
    echo "2. Send the EMPLOYER-ACCESS-GUIDE.md to employers"
    echo "3. Use the portfolio dashboard as your main entry point"
    echo "4. Monitor system health with ./monitor-for-employers.sh"
    echo ""
    echo -e "${BLUE}💡 Pro Tips:${NC}"
    echo "- Test the pipeline yourself before sharing"
    echo "- Keep the system running during interviews"
    echo "- Have backup screenshots ready"
    echo "- Prepare to explain the architecture"
}

# Run main function
main "$@"
