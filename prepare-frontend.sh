#!/bin/bash
# Script to prepare frontend assets for backend hosting

FRONTEND_WWWROOT="./EpargneArgents.Client.Web/wwwroot"
BACKEND_WWWROOT="./EpargneArgents.API/wwwroot"

# Create backend wwwroot if it doesn't exist
mkdir -p "$BACKEND_WWWROOT"

# Copy all frontend static files
echo "Copying frontend static files..."
cp -r "$FRONTEND_WWWROOT"/* "$BACKEND_WWWROOT/" 2>/dev/null || true

# Copy index.html for SPA routing
if [ -f "$FRONTEND_WWWROOT/index.html" ]; then
	cp "$FRONTEND_WWWROOT/index.html" "$BACKEND_WWWROOT/index.html"
	echo "✓ Frontend files copied successfully"
else
	echo "✗ Frontend index.html not found"
fi
