#!/usr/bin/env bash
# Runs Task C1 end to end and prints every value the workbook's "C1 evidence" table asks for.
# Usage (from the repo root):  bash scripts/evidence.sh
set -euo pipefail
cd "$(dirname "$0")/../nginx-web"
mkdir -p ../evidence

echo "== docker --version";            docker --version
echo "== Build";                       docker build -t my-nginx:1.0 .
docker rm -f web >/dev/null 2>&1 || true
echo "== Run";                         docker run -d --name web -p 8080:80 my-nginx:1.0
for i in $(seq 1 15); do curl -fs http://localhost:8080 >/dev/null && break; sleep 1; done

echo "== curl -i http://localhost:8080"; curl -si http://localhost:8080 | tee ../evidence/curl.txt
echo "== Custom 404 check";            curl -s -o /dev/null -w "HTTP %{http_code}\n" http://localhost:8080/missing
echo "== docker ps";                   docker ps --filter name=web
echo "== docker images";               docker images my-nginx
sleep 6
echo "== Health";                      docker inspect --format '{{.State.Health.Status}}' web
echo "== docker logs web";             docker logs web 2>&1 | tail -5 | tee ../evidence/logs.txt

echo
echo "Screenshot this terminal and http://localhost:8080 in your browser now."
read -rp "Press Enter to stop and remove the container... "
docker stop web && docker rm web
