# Jenkins Webhook Auto Deploy

DevOps portfolio project demonstrating
Jenkins-based automated testing and Docker deployment.

## Technologies
- GitHub
- Jenkins
- Docker
- Bash
- Nginx
- GitHub Webhooks (configuration stage)

## Pipeline
1. Checkout source code
2. Run automated tests
3. Build Docker image
4. Test candidate container
5. Deploy application
6. Verify HTTP response

## Local Tests
bash scripts/test.sh

## Local Deployment
bash scripts/deploy.sh

## Application
http://localhost:8082

## Notes
This is a local learning environment.
The deployment includes candidate validation
and basic recovery logic, not zero-downtime deployment.
