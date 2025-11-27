#!/bin/bash

set -e

echo "=== Starting rollback ==="

echo "1. Stopping version with issues..."
docker stop lab-webapp-deploy
docker rm lab-webapp-deploy

if ! docker images | grep -q 'sre-app:*previous'; then
    echo "❌ No previous version found."
    exit 1
fi

echo "2. Starting previous version..."
docker run -d --name lab-webapp-deploy -p 8080:8080 sre-app:previous

echo "3. Waiting for the app to start..."
sleep 5

echo "4. Testing Application..."
if curl -sf http://localhost:8080/health > /dev/null; then
    echo "✅ Rollback successful! Previous version is now running."
else
    echo "❌ Rollback failed!"
    exit 1
fi