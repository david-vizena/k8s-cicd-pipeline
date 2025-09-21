#!/bin/bash

# David Vizena - Complete Employer Visibility Setup
# Sets up multiple ways for employers to access your CI/CD portfolio

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}🎯 Complete Employer Visibility Setup${NC}"
echo -e "${PURPLE}Multiple ways for employers to see your CI/CD skills${NC}"
echo "====================================================="

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

# Create employer access summary
create_employer_summary() {
    echo -e "${BLUE}📋 Creating employer access summary...${NC}"
    
    cat > EMPLOYER-ACCESS-SUMMARY.md << 'EOF'
# 🎯 David Vizena - DevOps Portfolio Access

## 🚀 Live Demo Access

### **Main Portfolio Dashboard**
**URL**: [https://davidvizena-portfolio.railway.app](https://davidvizena-portfolio.railway.app)

### **Alternative Access Points**
- **Vercel**: [https://davidvizena-cicd.vercel.app](https://davidvizena-cicd.vercel.app)
- **Netlify**: [https://davidvizena-portfolio.netlify.app](https://davidvizena-portfolio.netlify.app)
- **GitHub Pages**: [https://davidvizena.github.io/k8s-ci-cd](https://davidvizena.github.io/k8s-ci-cd)

## 🔄 CI/CD Pipeline Components

### **GoCD Pipeline (CI/CD)**
- **Local Access**: `kubectl port-forward svc/gocd-server -n gocd 8153:8153`
- **URL**: http://localhost:8153
- **Username**: `demo`
- **Password**: `demo123`

### **ArgoCD (GitOps)**
- **Local Access**: `kubectl port-forward svc/argocd-server -n argocd 8080:443`
- **URL**: https://localhost:8080
- **Username**: `admin`
- **Password**: `admin123`

### **Live Application**
- **Local Access**: `kubectl port-forward svc/david-vizena-service -n david-vizena 3000:80`
- **URL**: http://localhost:3000

## 🧪 How to Test the Pipeline

1. **Start Local Environment**:
   ```bash
   ./deploy-local.sh
   ```

2. **Make a Change**:
   - Go to [GitHub Repository](https://github.com/davidvizena/k8s-ci-cd)
   - Edit any file (e.g., README.md)
   - Commit and push

3. **Watch the Pipeline**:
   - GoCD will automatically trigger
   - Watch build, test, and deploy stages
   - See ArgoCD sync the changes
   - View the updated application

## 🛠️ Technologies Demonstrated

- **Kubernetes**: Container orchestration
- **GoCD**: Continuous delivery
- **ArgoCD**: GitOps
- **Docker**: Containerization
- **Prometheus/Grafana**: Monitoring
- **OpenSearch**: Logging
- **AWS EKS**: Cloud infrastructure
- **GitHub Actions**: CI/CD integration

## 📞 Contact Information

- **Email**: david.vizena@example.com
- **LinkedIn**: [linkedin.com/in/davidvizena](https://linkedin.com/in/davidvizena)
- **GitHub**: [github.com/davidvizena](https://github.com/davidvizena)
- **Portfolio**: [davidvizena.dev](https://davidvizena.dev)

---

**This portfolio demonstrates real-world DevOps skills through a live, interactive CI/CD pipeline.**
EOF
    
    print_status "Employer access summary created"
}

# Setup local development environment
setup_local_environment() {
    echo -e "${BLUE}🏠 Setting up local development environment...${NC}"
    
    # Make scripts executable
    chmod +x deploy-local.sh
    chmod +x setup-cicd-complete.sh
    
    print_status "Local development environment ready"
}

# Create quick start guide
create_quick_start_guide() {
    echo -e "${BLUE}📖 Creating quick start guide...${NC}"
    
    cat > QUICK-START-FOR-EMPLOYERS.md << 'EOF'
# 🚀 Quick Start Guide for Employers

## ⚡ 5-Minute Demo Setup

### **Step 1: Start the Environment**
```bash
# Clone the repository
git clone https://github.com/davidvizena/k8s-ci-cd.git
cd k8s-ci-cd

# Start local CI/CD environment
./deploy-local.sh
```

### **Step 2: Access the Tools**
- **Portfolio Dashboard**: http://localhost:8080
- **GoCD Pipeline**: http://localhost:8153 (demo/demo123)
- **ArgoCD GitOps**: https://localhost:8080 (admin/admin123)
- **Live Application**: http://localhost:3000

### **Step 3: Test the Pipeline**
1. Make a small change to any file
2. Commit and push to GitHub
3. Watch the pipeline execute in GoCD
4. See deployment in ArgoCD
5. View the live application update

## 🎯 What to Look For

### **CI/CD Pipeline**
- ✅ Automated testing
- ✅ Security scanning
- ✅ Docker image building
- ✅ Multi-stage deployment
- ✅ GitOps synchronization

### **Infrastructure**
- ✅ Kubernetes orchestration
- ✅ Load balancing
- ✅ Health checks
- ✅ Resource management
- ✅ Monitoring and logging

### **Best Practices**
- ✅ Infrastructure as Code
- ✅ Security first approach
- ✅ Cost optimization
- ✅ Comprehensive documentation
- ✅ Automated deployments

## 📊 Portfolio Highlights

- **Real-World Implementation**: Not just demos, actual working systems
- **Cost-Conscious**: Optimized for free-tier usage
- **Security-Focused**: Automated vulnerability scanning
- **Scalable Architecture**: Designed for production use
- **Comprehensive Monitoring**: Full observability stack

## 🎤 Interview Discussion Points

1. **Pipeline Architecture**: How the CI/CD flow works
2. **Cost Optimization**: Free-tier management strategies
3. **Security Integration**: Automated scanning and compliance
4. **Monitoring Strategy**: Observability and alerting
5. **Scaling Considerations**: How to handle growth
6. **Troubleshooting**: Common issues and solutions

---

**This demonstrates real-world DevOps skills through a live, interactive CI/CD pipeline.**
EOF
    
    print_status "Quick start guide created"
}

# Create deployment scripts for different platforms
create_deployment_scripts() {
    echo -e "${BLUE}🚀 Creating deployment scripts...${NC}"
    
    # Railway deployment script
    cat > deploy-to-railway.sh << 'EOF'
#!/bin/bash
echo "🚀 Deploying to Railway..."

# Install Railway CLI if not present
if ! command -v railway &> /dev/null; then
    echo "Installing Railway CLI..."
    npm install -g @railway/cli
fi

# Login and deploy
railway login
railway init
railway up

echo "✅ Deployed to Railway!"
echo "🌐 Your app will be available at: https://your-app.railway.app"
EOF

    # Vercel deployment script
    cat > deploy-to-vercel.sh << 'EOF'
#!/bin/bash
echo "🚀 Deploying to Vercel..."

# Install Vercel CLI if not present
if ! command -v vercel &> /dev/null; then
    echo "Installing Vercel CLI..."
    npm install -g vercel
fi

# Deploy
vercel --prod

echo "✅ Deployed to Vercel!"
echo "🌐 Your app will be available at: https://your-app.vercel.app"
EOF

    chmod +x deploy-to-railway.sh
    chmod +x deploy-to-vercel.sh
    
    print_status "Deployment scripts created"
}

# Create QR codes for easy access
create_qr_codes() {
    echo -e "${BLUE}📱 Creating QR codes...${NC}"
    
    if command -v qrencode &> /dev/null; then
        # Create QR codes for different access points
        qrencode -t png -o portfolio-qr.png "https://davidvizena-portfolio.railway.app"
        qrencode -t png -o github-qr.png "https://github.com/davidvizena/k8s-ci-cd"
        qrencode -t png -o local-setup-qr.png "https://github.com/davidvizena/k8s-ci-cd#quick-start"
        
        print_status "QR codes created"
    else
        print_warning "qrencode not installed. Install with: brew install qrencode"
    fi
}

# Create employer presentation materials
create_presentation_materials() {
    echo -e "${BLUE}📊 Creating presentation materials...${NC}"
    
    # Create a simple presentation script
    cat > employer-presentation.md << 'EOF'
# 🎯 David Vizena - DevOps Portfolio Presentation

## 🎤 10-Minute Demo Script

### **Introduction (1 minute)**
"Hi, I'm David Vizena, and I'd like to show you my DevOps portfolio. This is a live CI/CD pipeline that demonstrates real-world skills in Kubernetes, GitOps, and continuous delivery."

### **Live Demo (5 minutes)**
1. **Show Portfolio Dashboard** (1 min)
   - Explain the architecture
   - Show system health
   - Highlight technologies used

2. **Trigger Pipeline** (2 min)
   - Make a small change to code
   - Push to GitHub
   - Show webhook trigger

3. **Watch Pipeline Execute** (2 min)
   - GoCD build stages
   - Security scanning
   - Docker image building
   - ArgoCD synchronization

### **Technical Deep Dive (3 minutes)**
- **Infrastructure**: Kubernetes, AWS EKS, Load Balancers
- **CI/CD**: GoCD, GitHub Actions, Automated testing
- **GitOps**: ArgoCD, Declarative deployments
- **Monitoring**: Prometheus, Grafana, OpenSearch
- **Security**: Trivy scanning, Best practices

### **Q&A (1 minute)**
- Cost optimization strategies
- Scaling considerations
- Troubleshooting approaches
- Security implementations

## 🎯 Key Points to Emphasize

1. **Real-World Implementation**: Not just demos, actual working systems
2. **Cost-Conscious**: Optimized for free-tier usage
3. **Security-Focused**: Automated vulnerability scanning
4. **Scalable Architecture**: Production-ready design
5. **Comprehensive Monitoring**: Full observability stack

## 📋 Backup Plan

If live demo fails:
1. Show screenshots of pipeline runs
2. Walk through the code repository
3. Explain the architecture
4. Discuss implementation details
EOF
    
    print_status "Presentation materials created"
}

# Main execution
main() {
    create_employer_summary
    setup_local_environment
    create_quick_start_guide
    create_deployment_scripts
    create_qr_codes
    create_presentation_materials
    
    echo ""
    echo -e "${GREEN}🎉 Employer Visibility Setup Complete!${NC}"
    echo "======================================"
    echo -e "${YELLOW}📋 What's Ready:${NC}"
    echo "✅ Local development environment"
    echo "✅ Employer access summary"
    echo "✅ Quick start guide"
    echo "✅ Deployment scripts for free hosting"
    echo "✅ QR codes for easy access"
    echo "✅ Presentation materials"
    echo ""
    echo -e "${BLUE}🚀 Next Steps:${NC}"
    echo "1. Run: ./deploy-local.sh (to start local environment)"
    echo "2. Run: ./deploy-to-railway.sh (to deploy to Railway)"
    echo "3. Share: EMPLOYER-ACCESS-SUMMARY.md with employers"
    echo "4. Practice: Use employer-presentation.md for demos"
    echo ""
    echo -e "${PURPLE}💡 Pro Tips:${NC}"
    echo "- Test everything before interviews"
    echo "- Keep local environment running during demos"
    echo "- Have backup screenshots ready"
    echo "- Practice the 10-minute demo script"
}

# Run main function
main "$@"
