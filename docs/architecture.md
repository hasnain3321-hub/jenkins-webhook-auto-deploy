# Architecture

GitHub Push
    |
    v
GitHub Webhook
    |
    v
Jenkins Pipeline
    |
    +-- Checkout
    +-- Automated Tests
    +-- Docker Build
    +-- Candidate Health Check
    +-- Deployment
    +-- Final HTTP Verification

Application: Nginx
Local Port: 8082

Note: Webhook setup requires a reachable
HTTPS endpoint for the local Jenkins server.
