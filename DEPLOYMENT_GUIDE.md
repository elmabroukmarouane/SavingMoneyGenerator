# Deployment Guide - EpargneArgents

## Overview

This guide covers deploying the EpargneArgents application to various environments.

## Prerequisites

- .NET 10.0 SDK (for manual deployment)
- Docker & Docker Compose (for containerized deployment)
- PowerShell or Bash shell
- Git (for version control)

## Local Development

### Quick Start

```bash
# Clone repository
git clone <repo-url>
cd EpargneArgents-master

# Start the application
# Windows
start.bat

# Linux/Mac
bash start.sh
```

The application will be available at:
- Frontend: http://localhost:5000
- API: http://localhost:5000/api
- Swagger: http://localhost:5000/swagger

### Manual Build & Run

```bash
# Restore packages
dotnet restore

# Build
dotnet build

# Prepare frontend assets (if needed)
powershell -ExecutionPolicy Bypass -File .\prepare-frontend.ps1

# Run
cd EpargneArgents.API
dotnet run
```

## Docker Deployment

### Build Docker Image

```bash
# Build image
docker build -t epargneargents-api:latest .

# Or with docker-compose
docker-compose build
```

### Run with Docker Compose

```bash
# Start services
docker-compose up -d

# View logs
docker-compose logs -f api

# Stop services
docker-compose down
```

### Run Docker Container

```bash
# Run container
docker run -p 5000:5000 -p 5001:5001 \
  -v csv_output:/app/GeneratedCsvOutputFolder \
  epargneargents-api:latest

# Run in background
docker run -d -p 5000:5000 -p 5001:5001 \
  -v csv_output:/app/GeneratedCsvOutputFolder \
  --name epargneargents \
  epargneargents-api:latest
```

## Production Deployment

### Azure App Service (Recommended)

#### Step 1: Prepare Application

```bash
# Clean and build
dotnet clean
dotnet build -c Release

# Prepare frontend
powershell -ExecutionPolicy Bypass -File .\prepare-frontend.ps1

# Publish
dotnet publish -c Release -o ./publish
```

#### Step 2: Create Azure Resources

```powershell
# Using Azure CLI
az group create --name epargneargents-rg --location eastus

az appservice plan create \
  --name epargneargents-plan \
  --resource-group epargneargents-rg \
  --sku B2 --is-linux

az webapp create \
  --resource-group epargneargents-rg \
  --plan epargneargents-plan \
  --name epargneargents-api \
  --runtime "DOTNETCORE:10.0"
```

#### Step 3: Deploy

```bash
# Deploy using publish profile
# Download publish profile from Azure Portal
# Then:
dotnet publish -c Release --publish-profile PublishProfile.pubxml

# Or via command line
az webapp up --resource-group epargneargents-rg \
  --name epargneargents-api \
  --plan epargneargents-plan \
  --runtime "DOTNETCORE:10.0"
```

#### Step 4: Configure Environment

In Azure Portal:
1. Go to Configuration > Application settings
2. Add/Update:
   ```
   ASPNETCORE_ENVIRONMENT=Production
   Parameters__Denominations=5;10;20;50;60
   Parameters__TotalAmount=10000
   Parameters__NumberDaysSaving=365
   Parameters__CsvFileName=DailyContributionCsvFile
   CorsName=CORSPOLICYSTRINGEPARGNEARGENTAPPAPI
   ```

### IIS Deployment (Windows Server)

#### Step 1: Prepare Application

```bash
# Publish for Windows hosting
dotnet publish -c Release -o C:\inetpub\wwwroot\epargneargents
```

#### Step 2: Configure IIS

1. Open IIS Manager
2. Create new Application Pool:
   - Name: EpargneArgents
   - Managed Runtime Version: No Managed Code
   - Pipeline Mode: Integrated

3. Create new Website:
   - Name: epargneargents
   - App Pool: EpargneArgents
   - Physical Path: C:\inetpub\wwwroot\epargneargents

4. Set Permissions:
   - Right-click folder > Properties > Security
   - Add IIS_IUSRS group with Read/Write permissions

5. Configure URL Rewrite (optional):
   - Install: [URL Rewrite Module](https://www.iis.net/downloads/microsoft/url-rewrite)
   - For SPA routing to index.html

#### Step 3: Verify Installation

Visit: `http://your-server/epargneargents`

### Linux Server (Ubuntu/Debian)

#### Step 1: Install .NET 10 Runtime

```bash
wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
chmod +x dotnet-install.sh
./dotnet-install.sh --runtime aspnetcore --version 10.0.0
```

#### Step 2: Deploy Application

```bash
# Create application directory
sudo mkdir -p /var/www/epargneargents
sudo chown -R $USER:$USER /var/www/epargneargents

# Copy published files
cp -r ./publish/* /var/www/epargneargents/

# Set permissions
sudo chmod -R 755 /var/www/epargneargents
```

#### Step 3: Create Systemd Service

Create `/etc/systemd/system/epargneargents.service`:

```ini
[Unit]
Description=EpargneArgents API
After=network.target

[Service]
Type=notify
User=www-data
WorkingDirectory=/var/www/epargneargents
ExecStart=/usr/local/share/dotnet/dotnet /var/www/epargneargents/EpargneArgents.API.dll
Restart=always
RestartSec=10
SyslogIdentifier=epargneargents
Environment="ASPNETCORE_ENVIRONMENT=Production"
Environment="ASPNETCORE_URLS=http://+:5000"

[Install]
WantedBy=multi-user.target
```

#### Step 4: Start Service

```bash
sudo systemctl daemon-reload
sudo systemctl enable epargneargents
sudo systemctl start epargneargents

# Check status
sudo systemctl status epargneargents
sudo journalctl -u epargneargents -f
```

#### Step 5: Configure Nginx Reverse Proxy

Create `/etc/nginx/sites-available/epargneargents`:

```nginx
server {
	listen 80;
	listen [::]:80;
	server_name your-domain.com;

	location / {
		proxy_pass http://localhost:5000;
		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection "upgrade";
		proxy_set_header Host $host;
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto $scheme;
	}
}
```

Enable site:
```bash
sudo ln -s /etc/nginx/sites-available/epargneargents /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

## Kubernetes Deployment

### 1. Create Kubernetes Resources

Create `k8s/deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: epargneargents-api
spec:
  replicas: 3
  selector:
	matchLabels:
	  app: epargneargents-api
  template:
	metadata:
	  labels:
		app: epargneargents-api
	spec:
	  containers:
	  - name: api
		image: epargneargents-api:latest
		ports:
		- containerPort: 5000
		env:
		- name: ASPNETCORE_ENVIRONMENT
		  value: "Production"
		- name: ASPNETCORE_URLS
		  value: "http://+:5000"
		livenessProbe:
		  httpGet:
			path: /
			port: 5000
		  initialDelaySeconds: 10
		  periodSeconds: 10
		readinessProbe:
		  httpGet:
			path: /
			port: 5000
		  initialDelaySeconds: 5
		  periodSeconds: 5
```

### 2. Deploy to Kubernetes

```bash
# Create namespace
kubectl create namespace epargneargents

# Deploy
kubectl apply -f k8s/ -n epargneargents

# Check deployment
kubectl get deployments -n epargneargents
kubectl get pods -n epargneargents

# View logs
kubectl logs -f deployment/epargneargents-api -n epargneargents
```

## Verification Checklist

After deployment, verify:

- [ ] Frontend loads at root URL
- [ ] API endpoints respond
- [ ] Swagger documentation accessible
- [ ] CSV generation works
- [ ] Health check passes
- [ ] Logs show no errors
- [ ] Database/persistence working (if applicable)
- [ ] CORS configured correctly
- [ ] SSL/HTTPS working (if applicable)

### Quick Health Check

```bash
# Windows
health-check.bat

# Linux/Mac
bash health-check.sh

# Or manual curl
curl http://localhost:5000/
curl http://localhost:5000/swagger
curl -X POST http://localhost:5000/api/DailyContribution \
  -H "Content-Type: application/json" \
  -d '{"totalAmount":10000,"denominations":"5;10;20;50;60","numberDaysSaving":365}'
```

## Troubleshooting

### Application Won't Start

```bash
# Check logs
dotnet EpargneArgents.API.dll --verbose

# Verify port availability
# Windows
netstat -ano | findstr :5000

# Linux
sudo lsof -i :5000
```

### Port Already in Use

```bash
# Kill process on port 5000
# Windows
netstat -ano | findstr :5000
taskkill /PID <PID> /F

# Linux
sudo kill -9 $(lsof -t -i:5000)
```

### Frontend Not Loading

1. Check that `wwwroot/index.html` exists
2. Run `prepare-frontend.ps1`
3. Verify static files are configured in `Program.cs`

### API Endpoint Not Found

1. Check controller routing is correct
2. Verify endpoint URL matches request
3. Check for CORS issues in browser console

### CSV Generation Fails

1. Check `GeneratedCsvOutputFolder` permissions
2. Verify parameters are valid
3. Check available disk space
4. Review logs for detailed error

## Monitoring & Logs

### Application Insights (Azure)

```bash
# Add Application Insights
dotnet add package Microsoft.ApplicationInsights.AspNetCore

# Configure in Program.cs
services.AddApplicationInsightsTelemetry();
```

### Structured Logging

```bash
# Add Serilog
dotnet add package Serilog
dotnet add package Serilog.Sinks.Console
dotnet add package Serilog.Sinks.File
```

### View Logs

```bash
# Docker
docker-compose logs -f api

# Systemd
sudo journalctl -u epargneargents -f

# Application Insights
# Via Azure Portal
```

## Performance Optimization

1. **Enable Response Compression**
   - Add: `services.AddResponseCompression()`
   - Add: `app.UseResponseCompression()`

2. **Static File Caching**
   - Configure cache headers in `Program.cs`

3. **Database Connection Pooling**
   - Adjust connection pool size if using database

4. **Load Testing**
   ```bash
   # Using Apache Bench
   ab -n 1000 -c 10 http://localhost:5000/
   ```

## Rollback Procedure

```bash
# Docker
docker-compose down
docker rmi epargneargents-api:latest
docker-compose up -d

# Kubernetes
kubectl rollout history deployment/epargneargents-api -n epargneargents
kubectl rollout undo deployment/epargneargents-api -n epargneargents
```

---

**Last Updated:** May 25, 2026
**Application Version:** 1.0.0
**Framework:** .NET 10.0
