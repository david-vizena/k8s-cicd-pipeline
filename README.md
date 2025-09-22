# David Vizena - CI/CD Pipeline Portfolio Project

A comprehensive CI/CD pipeline showcasing modern DevOps practices with React, Kubernetes, GitHub Actions, and AWS EKS. This project demonstrates automated testing, containerization, and cloud-native deployment strategies optimized for free-tier hosting.

## 🚀 Features

### Core Application
- **React Frontend**: Modern, responsive UI with Tailwind CSS
- **Docker Containerization**: Multi-stage build for optimized production image
- **Kubernetes Deployment**: Scalable deployment with network policies

### CI/CD Pipeline
- **GitHub Actions**: Industry-standard CI/CD with automated pipelines
- **Automated Testing**: Unit tests, linting, and build validation
- **Docker Packaging**: Multi-stage container builds for production
- **Container Registry**: GitHub Container Registry for image storage

### Observability & Monitoring
- **OpenSearch**: Centralized logging and search capabilities
- **Fluent Bit**: Log collection and forwarding
- **Prometheus & Grafana**: Metrics collection and visualization

### Cloud Infrastructure
- **AWS EKS**: Managed Kubernetes cluster (free tier)
- **Application Load Balancer**: High availability with SSL termination
- **100% Free**: Optimized for AWS free tier with no additional costs
- **Alternative Hosting**: Railway, Render, and Vercel options included

## 🌐 Live Demo

**Production Application**: [david-vizena-portfolio.com](https://david-vizena-portfolio.com) (coming soon)
**GitHub Actions**: [View CI/CD Pipeline](https://github.com/david-vizena/k8s-cicd-pipeline/actions) (live)
**Container Registry**: [View Docker Images](https://github.com/david-vizena/k8s-cicd-pipeline/pkgs/container/k8s-cicd-pipeline) (live)

**CI/CD Pipeline Features**:
- **Automated Testing**: Unit tests, linting, and build validation
- **Containerization**: Docker multi-stage builds for production
- **GitHub Actions**: Industry-standard CI/CD with automatic triggers
- **Free-Tier Optimized**: AWS EKS deployment with minimal resource usage

## 🛠️ Tech Stack

- **Frontend**: React 18, Tailwind CSS
- **Containerization**: Docker, Nginx
- **Orchestration**: Kubernetes
- **CI/CD**: GitHub Actions
- **Cloud**: AWS EKS
- **Observability**: OpenSearch, Fluent Bit, Prometheus, Grafana
- **Version Control**: Git, GitHub

## 📦 Quick Start (100% Free Options)

### Option 1: Local Development (Recommended for Learning)
```bash
# Clone and setup locally (no cloud costs!)
git clone https://github.com/davidvizena/k8s-ci-cd.git
cd k8s-ci-cd
./deploy-local.sh
```

### Option 2: AWS Free Tier
```bash
# Deploy to AWS using free tier
./deploy-cicd.sh --freetier
```

### Option 3: Railway (Easiest Cloud Option)
```bash
# Connect GitHub repo to Railway
# Automatic deployments, 500 hours/month free
```

### Prerequisites

**For Local Development:**
- Node.js 18+
- Docker
- Minikube
- kubectl
- Helm

**For AWS Free Tier:**
- AWS Account (free tier)
- eksctl
- AWS CLI configured

### Local Development

1. **Install dependencies**:
   ```bash
   npm install
   ```

2. **Start development server**:
   ```bash
   npm start
   ```

3. **Build for production**:
   ```bash
   npm run build
   ```

### Docker Deployment

1. **Build Docker image**:
   ```bash
   docker build -t davidvizena/hello-world:latest .
   ```

2. **Run locally**:
   ```bash
   docker run -p 8080:8080 davidvizena/hello-world:latest
   ```

### Kubernetes Deployment

1. **Start minikube cluster**:
   ```bash
   minikube start
   ```

2. **Deploy to Kubernetes**:
   ```bash
   ./deploy.sh
   ```

3. **Or deploy manually**:
   ```bash
   kubectl apply -f k8s/
   ```

4. **Get service URL**:
   ```bash
   minikube service david-vizena-service -n david-vizena
   ```

## 🆓 Free Hosting & Development Options

### Local Development (100% Free)
- **Minikube**: Local Kubernetes cluster
- **Docker**: Container runtime
- **ArgoCD**: GitOps locally
- **Prometheus/Grafana**: Monitoring stack
- **No cloud costs**: Everything runs on your machine

### Cloud Free Tiers

#### AWS Free Tier
- **EKS**: First cluster free
- **EC2**: 750 hours/month t3.micro
- **EBS**: 30GB storage
- **Load Balancer**: 750 hours/month
- **Cost**: $0/month (with proper configuration)

#### Railway
- **Free Tier**: 500 hours/month
- **Automatic Deployments**: GitHub integration
- **Custom Domains**: Free subdomains
- **Cost**: $0/month

#### Render
- **Free Tier**: 750 hours/month
- **Static Sites**: Unlimited
- **SSL Certificates**: Automatic
- **Cost**: $0/month

#### Vercel
- **Free Tier**: Unlimited static sites
- **Automatic Deployments**: GitHub integration
- **Global CDN**: Included
- **Cost**: $0/month

## 📁 Project Structure

```
├── src/
│   ├── App.js          # Main React component
│   ├── index.js        # React entry point
│   └── index.css       # Tailwind CSS imports
├── public/
│   └── index.html      # HTML template
├── k8s/
│   ├── namespace.yaml  # Kubernetes namespace
│   ├── deployment.yaml # App deployment
│   ├── service.yaml    # LoadBalancer service
│   ├── ingress.yaml    # Ingress configuration
│   └── network-policy.yaml # Network policies
├── .github/workflows/
│   └── ci-cd.yml       # GitHub Actions CI/CD pipeline
├── Dockerfile          # Multi-stage Docker build
├── nginx.conf          # Nginx configuration
└── deploy.sh           # Deployment script
```

## 🔧 Configuration

### Environment Variables
- `PORT`: Application port (default: 8080)

### Kubernetes Resources
- **CPU**: 50m request, 100m limit
- **Memory**: 64Mi request, 128Mi limit
- **Replicas**: 2 (for high availability)


## 🚀 Portfolio Series Overview

This is **Project 1** of a 4-project portfolio series demonstrating full-stack DevOps skills:

### **Project 1: Foundation** (Current)
- ✅ React Frontend + Tailwind CSS
- ✅ Docker Containerization
- ✅ Kubernetes Orchestration
- ✅ Network Policies & Security

### **Project 2: Monitoring & Observability** (Coming Soon)
- 🔄 Grafana Dashboards
- 🔄 Prometheus Metrics
- 🔄 Alerting & Incident Response
- 🔄 Log Aggregation

### **Project 3: CI/CD & GitOps** (Current)
- ✅ GitHub Actions Pipeline Automation
- ✅ Docker Containerization
- ✅ Kubernetes Orchestration
- ✅ AWS EKS Deployment
- ✅ 100% Free-Tier Compatible

### **Project 4: Security & Secrets Management** (Coming Soon)
- 🔄 HashiCorp Vault
- 🔄 RBAC & Access Control
- 🔄 Encryption & Data Protection
- 🔄 Security Scanning

## 📝 License

MIT License - feel free to use this as a template for your own portfolio projects!

---

**Built with ❤️ by David Vizena**

---

## 📞 Contact

**David Vizena**  
DevOps Engineer | Cloud Architect  
📧 davidvizena@gmail.com  
🔗 [GitHub](https://github.com/david-vizena)  
🌐 [Portfolio](https://david-vizena-portfolio.com)

*This project demonstrates professional DevOps practices and is optimized for free-tier cloud hosting.*
