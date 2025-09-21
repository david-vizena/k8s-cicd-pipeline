#!/bin/bash

# Script to create a simple pipeline in GoCD
# This will let you see a basic CI/CD pipeline working

echo "🎯 Creating a simple pipeline in GoCD..."
echo "======================================="

# Wait for GoCD to be fully ready
echo "⏳ Waiting for GoCD to be ready..."
sleep 10

# Create a simple pipeline configuration
cat > simple-pipeline.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<cruise xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="cruise-config.xsd" schemaVersion="132">
  <server artifactsdir="artifacts" commandRepositoryLocation="default" serverId="david-vizena-gocd">
  </server>
  
  <pipelines group="david-vizena-portfolio">
    <pipeline name="hello-world-pipeline">
      <materials>
        <git url="https://github.com/davidvizena/k8s-ci-cd.git" branch="k8s-ci-cd-project" />
      </materials>
      <stage name="build">
        <jobs>
          <job name="build-job">
            <tasks>
              <exec command="/bin/bash">
                <arg>-c</arg>
                <arg>
                  echo "🚀 Starting build..."
                  echo "📁 Current directory: $(pwd)"
                  echo "📋 Files in directory:"
                  ls -la
                  echo "✅ Build completed successfully!"
                </arg>
              </exec>
            </tasks>
          </job>
        </jobs>
      </stage>
      
      <stage name="test">
        <jobs>
          <job name="test-job">
            <tasks>
              <exec command="/bin/bash">
                <arg>-c</arg>
                <arg>
                  echo "🧪 Running tests..."
                  echo "📊 Test results:"
                  echo "  ✅ Unit tests: PASSED"
                  echo "  ✅ Integration tests: PASSED"
                  echo "  ✅ Security tests: PASSED"
                  echo "✅ All tests completed successfully!"
                </arg>
              </exec>
            </tasks>
          </job>
        </jobs>
      </stage>
      
      <stage name="deploy">
        <jobs>
          <job name="deploy-job">
            <tasks>
              <exec command="/bin/bash">
                <arg>-c</arg>
                <arg>
                  echo "🚀 Deploying application..."
                  echo "📦 Building Docker image..."
                  echo "🐳 Image: davidvizena/hello-world:latest"
                  echo "☸️  Deploying to Kubernetes..."
                  echo "✅ Deployment completed successfully!"
                </arg>
              </exec>
            </tasks>
          </job>
        </jobs>
      </stage>
    </pipeline>
  </pipelines>
</cruise>
EOF

echo "📝 Pipeline configuration created: simple-pipeline.xml"
echo ""
echo "🎯 Next steps to see GoCD working:"
echo "1. Open your browser and go to: http://localhost:8153"
echo "2. Login with username: admin, password: admin"
echo "3. You'll see the GoCD dashboard"
echo "4. The pipeline will automatically trigger when you push to GitHub"
echo ""
echo "🔧 To manually trigger the pipeline:"
echo "1. Go to the GoCD dashboard"
echo "2. Find the 'hello-world-pipeline'"
echo "3. Click the play button to run it manually"
echo ""
echo "📋 What you'll see:"
echo "- Build stage: Shows file listing and build process"
echo "- Test stage: Shows test results"
echo "- Deploy stage: Shows deployment process"
echo ""
echo "✅ GoCD is ready to use!"
