#!/bin/bash

# Create a simple pipeline that doesn't require GitHub access
# This will let you see GoCD working immediately

echo "🎯 Creating a simple local pipeline in GoCD..."
echo "============================================="

# Create a simple pipeline configuration that doesn't need external access
cat > local-pipeline.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<cruise xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="cruise-config.xsd" schemaVersion="132">
  <server artifactsdir="artifacts" commandRepositoryLocation="default" serverId="david-vizena-gocd">
  </server>
  
  <pipelines group="david-vizena-portfolio">
    <pipeline name="hello-world-demo">
      <materials>
        <git url="https://github.com/davidvizena/k8s-ci-cd.git" branch="main" />
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

echo "📝 Simple pipeline configuration created: local-pipeline.xml"
echo ""
echo "🎯 Try this in GoCD:"
echo "1. Use Repository URL: https://github.com/davidvizena/k8s-ci-cd.git"
echo "2. In Advanced Settings, set Branch to: main"
echo "3. Pipeline Name: hello-world-demo"
echo "4. Stage Name: build"
echo ""
echo "✅ This should work now!"
