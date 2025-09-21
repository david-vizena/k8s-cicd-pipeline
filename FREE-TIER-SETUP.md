# 🆓 Free-Tier CI/CD Setup Guide

This guide ensures you can run the entire CI/CD pipeline without spending any money on cloud services.

## 🎯 Free-Tier Strategy

### AWS Free Tier Limits
- **EC2**: 750 hours/month of t2.micro instances
- **EBS**: 30 GB of General Purpose (SSD) storage
- **Load Balancer**: 750 hours/month + 15 GB data processing
- **EKS**: First cluster is free (but nodes cost money)
- **Route 53**: First hosted zone free

### Our Free-Tier Optimizations
1. **Single t3.micro node** (750 hours free)
2. **Minimal storage** (8GB EBS volumes)
3. **No auto-scaling** (prevents unexpected costs)
4. **Disabled expensive features** (X-Ray, App Mesh, etc.)
5. **Minimal logging** (reduces CloudWatch costs)

## 🚀 Deployment Options (All Free)

### Option 1: AWS EKS (Recommended for Learning)
```bash
# Use the free-tier optimized configuration
./deploy-cicd.sh --freetier
```

### Option 2: Local Development with Minikube
```bash
# Install minikube
brew install minikube  # macOS
# or
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Start cluster
minikube start --memory=4096 --cpus=2

# Deploy locally
kubectl apply -f k8s/
```

### Option 3: Railway (Easiest)
```bash
# Connect GitHub repo to Railway
# Automatic deployments on push
# Free tier: 500 hours/month
```

### Option 4: Render (Great for Static Sites)
```bash
# Connect GitHub repo to Render
# Free tier: 750 hours/month
# Automatic SSL certificates
```

### Option 5: Vercel (Perfect for React)
```bash
# Connect GitHub repo to Vercel
# Free tier: Unlimited static sites
# Automatic deployments
```

## 💰 Cost Monitoring

### AWS Cost Alerts
```bash
# Set up billing alerts
aws budgets create-budget \
  --account-id YOUR_ACCOUNT_ID \
  --budget '{
    "BudgetName": "Free-Tier-Monitor",
    "BudgetLimit": {"Amount": "5.00", "Unit": "USD"},
    "TimeUnit": "MONTHLY",
    "BudgetType": "COST"
  }'
```

### Free-Tier Usage Check
```bash
# Check free-tier usage
aws ce get-cost-and-usage \
  --time-period Start=2024-01-01,End=2024-01-31 \
  --granularity MONTHLY \
  --metrics BlendedCost
```

## 🔧 Free-Tier Optimizations

### Kubernetes Resources
```yaml
# All resources optimized for free tier
resources:
  requests:
    memory: "32Mi"    # Minimal memory
    cpu: "25m"        # Minimal CPU
  limits:
    memory: "64Mi"    # Small limits
    cpu: "50m"        # Small limits
```

### Storage Configuration
```yaml
# Minimal storage usage
persistence:
  size: "5Gi"         # Small volumes
  storageClassName: "gp2"  # Standard storage
```

### Disabled Features
- ❌ Auto-scaling (prevents cost spikes)
- ❌ X-Ray tracing (expensive)
- ❌ App Mesh (not needed)
- ❌ EFS (expensive)
- ❌ CloudWatch detailed logging (expensive)

## 🚨 Cost Prevention Checklist

- [ ] Use t3.micro instances only
- [ ] Set max nodes to 1
- [ ] Disable auto-scaling
- [ ] Use minimal storage (8GB max)
- [ ] Disable expensive add-ons
- [ ] Set up billing alerts
- [ ] Monitor usage weekly
- [ ] Use free domain services (Freenom, etc.)

## 🆓 Free Domain Options

### Freenom (Free .tk, .ml, .ga domains)
1. Go to [freenom.com](https://freenom.com)
2. Search for available domains
3. Register for free (1 year)
4. Point DNS to your load balancer

### Cloudflare (Free DNS)
1. Sign up for free Cloudflare account
2. Add your domain
3. Use Cloudflare's free DNS
4. Enable free SSL certificates

## 📊 Monitoring Without Costs

### Free Monitoring Stack
- **Prometheus**: Open-source metrics (free)
- **Grafana**: Open-source dashboards (free)
- **OpenSearch**: Open-source logging (free)
- **Fluent Bit**: Open-source log collection (free)

### Alternative Free Services
- **Uptime Robot**: Free uptime monitoring
- **StatusCake**: Free website monitoring
- **Pingdom**: Free basic monitoring

## 🎯 Portfolio Benefits

This free-tier setup demonstrates:
- **Cost Optimization**: Understanding cloud economics
- **Resource Management**: Efficient resource allocation
- **Monitoring**: Observability without breaking the bank
- **Automation**: CI/CD without expensive tools
- **Security**: Free security scanning tools

## 🚀 Next Steps

1. **Choose your deployment option** (AWS EKS recommended)
2. **Set up billing alerts** (critical!)
3. **Deploy using free-tier config**
4. **Monitor costs weekly**
5. **Document your learnings**

Remember: The goal is to learn DevOps practices without spending money. This setup proves you can build enterprise-grade CI/CD pipelines on a budget!
