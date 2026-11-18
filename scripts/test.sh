#!/usr/bin/env bash
set -euo pipefail

echo "Starting automated tests..."

test -f app/index.html
echo "PASS: Application exists"

grep -q "Jenkins CI/CD Automation" app/index.html
echo "PASS: Application title"

grep -q "Version 1.0" app/index.html
echo "PASS: Application version"

test -f Dockerfile
echo "PASS: Dockerfile exists"

echo "All tests passed!"
