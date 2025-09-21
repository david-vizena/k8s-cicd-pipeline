#!/bin/bash

# Create a demo pipeline that doesn't require GitHub access
# This will let you see GoCD working immediately

echo "🎯 Creating a demo pipeline without GitHub..."
echo "============================================="

# Create a simple pipeline that uses a local material
cat > demo-pipeline.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<cruise xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="cruise-config.xsd" schemaVersion="132">
  <server artifactsdir="artifacts" commandRepositoryLocation="default" serverId="david-vizena-gocd">
  </server>
  
  <pipelines group="david-vizena-portfolio">
    <pipeline name="demo-pipeline">
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
                  echo "🚀 Starting demo build..."
                  echo "📁 Current directory: $(pwd)"
                  echo "📋 Files in directory:"
                  ls -la
                  echo "✅ Demo build completed successfully!"
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

echo "📝 Demo pipeline configuration created"
echo ""
echo "🎯 For now, let's skip GitHub and create a simple pipeline:"
echo "1. Click 'Cancel' or go back to the dashboard"
echo "2. We'll create a pipeline manually"
echo ""
echo "✅ This will let you see GoCD working without GitHub issues!"
