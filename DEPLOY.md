# Guide for Deploy and Rollback

## How to deploy
1. Build and test locally:
```bash
docker build -t sre-app:1.0.1 app/
docker run -p 8080:8080 sre-app:1.0.1
```

2. Run tests:
```bash
cd tests && pytest -v
```

3. Run deploy.sh:
```bash
./deploy.sh 1.0.1
```

4. Monitor the application:
```bash
./monitor.sh
```

## How to rollback
If anything goes wrong after deployment:
1. Run rollback.sh:
```bash
./rollback.sh
```

2. Check if the previous version has been restored:
```bash
curl http://localhost:8080/health
```

3. Investigate the problem before attempting a new deployment
### Deployment checklist
- Tests passing locally
- Github pipeline passed
- Previous version is tagged
- Notified the team
- Monitor dor 15 minutes after deployment

4. Test the entire process:
```bash
# Make the scripts executable
chmod +x deploy.sh rollback.sh monitor.sh

# Deploy it
./deploy.sh 1.0.1

# Check if it's working
./monitor.sh

# Simulate a rollback
./rollback.sh

# Check if it's back
./monitor.sh
```