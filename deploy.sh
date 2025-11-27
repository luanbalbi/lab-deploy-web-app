#!/bin/bash

set -e

VERSION=$1

if [ -z "$VERSION" ]; then
    echo "Usage: ./deploy.sh <version>"
    echo "Example: ./deploy.sh 1.0.0"
    exit 1
fi

echo "=== Deploying version $VERSION ==="

echo "1. Building Docker image..."
docker build -t sre-app:$VERSION app/

echo "2. Stopping existing container (if any)..."
docker stop lab-webapp-deploy 2>/dev/null || true
docker rm lab-webapp-deploy 2>/dev/null || true

echo "3. Saving previous version..."
docker tag sre-app:$VERSION sre-app:previous || true

echo "4. Starting new version..."
docker run -d --name lab-webapp-deploy -p 8080:8080 \
    -e APP_VERSION=$VERSION \
    sre-app:$VERSION

echo "5. Waiting for the app to start..."
sleep 5

echo "6. Testing health check..."
for i in {1..5}; do
    if curl -sf http://localhost:8080/health > /dev/null; then
        echo "✅ Deploy finished with success!"
        echo "Version $VERSION is now running."
        exit 0
    fi
    echo "Attempt $i/5 failed, waiting..."
    sleep 2
done

echo "❌ Deploy failed! Execute rollback manually."
exit 1