#!/bin/bash

# CI/CD Pipeline Deployment Script for David Vizena Portfolio
# This script builds and deploys the React application to Kubernetes

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Building and deploying David Vizena CI/CD Portfolio...${NC}"

# Build Docker image
echo -e "${BLUE}📦 Building Docker image...${NC}"
docker build -t davidvizena/cicd-portfolio:latest .

# Load image into minikube (for local development)
echo -e "${BLUE}📤 Loading image into minikube...${NC}"
minikube image load davidvizena/cicd-portfolio:latest

# Deploy to Kubernetes
echo -e "${BLUE}☸️  Deploying to Kubernetes...${NC}"
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/network-policy.yaml

# Wait for deployment to be ready
echo -e "${YELLOW}⏳ Waiting for deployment to be ready...${NC}"
kubectl wait --for=condition=available --timeout=300s deployment/david-vizena-app -n david-vizena

# Get service info
echo -e "${BLUE}🌐 Getting service information...${NC}"
kubectl get service david-vizena-service -n david-vizena

echo -e "${GREEN}✅ Deployment complete!${NC}"
echo -e "${GREEN}🔗 Your CI/CD Portfolio app should be accessible via the LoadBalancer external IP${NC}"
echo -e "${YELLOW}📊 To view the app: minikube service david-vizena-service -n david-vizena${NC}"
