# Windows PowerShell version of scripts/evidence.sh
# Usage (from the repo root):  powershell -ExecutionPolicy Bypass -File scripts\evidence.ps1
$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..\nginx-web")

Write-Host "== docker --version";  docker --version
Write-Host "== Build";             docker build -t my-nginx:1.0 .
docker rm -f web 2>$null | Out-Null
Write-Host "== Run";               docker run -d --name web -p 8080:80 my-nginx:1.0
Start-Sleep -Seconds 3

Write-Host "== HTTP test"
$r = Invoke-WebRequest -Uri http://localhost:8080 -UseBasicParsing
"HTTP $($r.StatusCode)"; $r.Content
Write-Host "== Custom 404 check"
try { Invoke-WebRequest -Uri http://localhost:8080/missing -UseBasicParsing | Out-Null }
catch { "HTTP $($_.Exception.Response.StatusCode.value__)" }

Write-Host "== docker ps";         docker ps --filter name=web
Write-Host "== docker images";     docker images my-nginx
Start-Sleep -Seconds 6
Write-Host "== Health";            docker inspect --format '{{.State.Health.Status}}' web
Write-Host "== docker logs web";   docker logs web 2>&1 | Select-Object -Last 5

Write-Host "`nScreenshot this window and http://localhost:8080 in your browser now."
Read-Host "Press Enter to stop and remove the container"
docker stop web; docker rm web
