#!/usr/bin/env bash
set -euo pipefail

IMAGE="jenkins-webhook-app:${BUILD_NUMBER:-local}"
CONTAINER="jenkins-webhook-app"
BACKUP="${CONTAINER}-backup"
PORT=8082

echo "Building Docker image..."
docker build -t "$IMAGE" .

echo "Starting candidate container..."
docker rm -f "${CONTAINER}-candidate" 2>/dev/null || true
docker run -d \
  --name "${CONTAINER}-candidate" \
  "$IMAGE"

echo "Testing candidate..."
READY=0
for i in $(seq 1 15); do
  if docker exec "${CONTAINER}-candidate" \
    wget -q -O - http://127.0.0.1/ \
    | grep -q "Deployment Successful"; then
    READY=1
    break
  fi
  sleep 2
done

if [ "$READY" -ne 1 ]; then
  echo "Candidate health check failed"
  docker logs "${CONTAINER}-candidate"
  docker rm -f "${CONTAINER}-candidate"
  exit 1
fi

echo "Candidate passed. Deploying..."

docker rm -f "$BACKUP" 2>/dev/null || true

if docker container inspect "$CONTAINER" >/dev/null 2>&1; then
  docker stop "$CONTAINER"
  docker rename "$CONTAINER" "$BACKUP"
fi

docker rm -f "${CONTAINER}-candidate"

if docker run -d \
  --name "$CONTAINER" \
  -p 127.0.0.1:${PORT}:80 \
  "$IMAGE" &&
  curl --retry 10 --retry-delay 2 \
    --retry-connrefused -fsS \
    http://127.0.0.1:${PORT}/ \
    | grep -q "Deployment Successful"; then
  echo "Deployment successful!"
  docker rm -f "$BACKUP" 2>/dev/null || true
else
  echo "Deployment failed. Restoring previous container."
  docker rm -f "$CONTAINER" 2>/dev/null || true
  if docker container inspect "$BACKUP" >/dev/null 2>&1; then
    docker rename "$BACKUP" "$CONTAINER"
    docker start "$CONTAINER"
  fi
  exit 1
fi
