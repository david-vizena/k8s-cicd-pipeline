#!/bin/bash

# Simple script to run GoCD locally with Docker
# This will let you actually see GoCD working

set -e

echo "🎯 Starting GoCD locally with Docker..."
echo "======================================"

# Stop any existing GoCD containers
echo "🧹 Cleaning up any existing GoCD containers..."
docker stop gocd-server gocd-agent 2>/dev/null || true
docker rm gocd-server gocd-agent 2>/dev/null || true

# Start GoCD Server
echo "🚀 Starting GoCD Server..."
docker run -d \
  --name gocd-server \
  -p 8153:8153 \
  -p 8154:8154 \
  -e GO_SERVER_SYSTEM_PROPERTIES="-Dgo.plugin.upload.enabled=true" \
  gocd/gocd-server:v23.3.0

# Wait for server to start
echo "⏳ Waiting for GoCD server to start..."
sleep 30

# Start GoCD Agent
echo "🤖 Starting GoCD Agent..."
docker run -d \
  --name gocd-agent \
  --link gocd-server:gocd-server \
  -e GO_SERVER_URL=https://gocd-server:8154/go \
  gocd/gocd-agent-docker-dind:v23.3.0

echo ""
echo "✅ GoCD is now running!"
echo "======================"
echo "🌐 GoCD URL: http://localhost:8153"
echo "👤 Username: admin"
echo "🔑 Password: admin"
echo ""
echo "📝 To access GoCD:"
echo "1. Open your browser"
echo "2. Go to: http://localhost:8153"
echo "3. Login with admin/admin"
echo "4. You'll see the GoCD dashboard"
echo ""
echo "🛑 To stop GoCD:"
echo "docker stop gocd-server gocd-agent"
echo "docker rm gocd-server gocd-agent"
echo ""
echo "🔍 To check if it's running:"
echo "docker ps | grep gocd"
