import React from 'react';

function App() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center">
      <div className="max-w-4xl mx-auto px-6 text-center">
        <div className="bg-white rounded-2xl shadow-2xl p-12 transform hover:scale-105 transition-transform duration-300">
          <h1 className="text-6xl font-bold text-gray-800 mb-6">
            David Vizena
          </h1>
          <h2 className="text-2xl font-semibold text-blue-600 mb-4">
            DevOps Engineer | Cloud Architect
          </h2>
          <p className="text-xl text-gray-600 mb-8">
            Welcome to my CI/CD Pipeline Portfolio! This application demonstrates modern DevOps practices
            including automated testing, containerization, Kubernetes orchestration, and GitHub Actions CI/CD.
          </p>
          <div className="flex flex-wrap justify-center gap-3 mb-8">
            <div className="bg-blue-100 text-blue-800 px-4 py-2 rounded-full text-sm font-medium">
              React 18
            </div>
            <div className="bg-green-100 text-green-800 px-4 py-2 rounded-full text-sm font-medium">
              Tailwind CSS
            </div>
            <div className="bg-orange-100 text-orange-800 px-4 py-2 rounded-full text-sm font-medium">
              Docker
            </div>
            <div className="bg-purple-100 text-purple-800 px-4 py-2 rounded-full text-sm font-medium">
              Kubernetes
            </div>
            <div className="bg-red-100 text-red-800 px-4 py-2 rounded-full text-sm font-medium">
              GitHub Actions
            </div>
            <div className="bg-indigo-100 text-indigo-800 px-4 py-2 rounded-full text-sm font-medium">
              CI/CD Pipeline
            </div>
            <div className="bg-yellow-100 text-yellow-800 px-4 py-2 rounded-full text-sm font-medium">
              AWS EKS
            </div>
          </div>
          <div className="bg-gray-50 rounded-lg p-6 text-left">
            <h3 className="text-lg font-semibold text-gray-800 mb-3">🚀 CI/CD Pipeline Features</h3>
            <ul className="space-y-2 text-gray-600">
              <li>✅ Automated testing with npm test</li>
              <li>✅ Docker containerization with multi-stage builds</li>
              <li>✅ Kubernetes deployment with health checks</li>
              <li>✅ GitHub Actions CI/CD automation</li>
              <li>✅ Free-tier optimized for AWS EKS</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  );
}

export default App;
