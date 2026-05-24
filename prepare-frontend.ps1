# Script to prepare frontend assets for backend hosting
# Run this before building/publishing the API

$frontendWwwroot = ".\EpargneArgents.Client.Web\wwwroot"
$backendWwwroot = ".\EpargneArgents.API\wwwroot"

# Create backend wwwroot if it doesn't exist
if (-not (Test-Path $backendWwwroot)) {
	New-Item -ItemType Directory -Path $backendWwwroot -Force | Out-Null
	Write-Host "Created wwwroot directory"
}

# Copy all frontend static files
if (Test-Path $frontendWwwroot) {
	Write-Host "Copying frontend static files..."
	Copy-Item -Path "$frontendWwwroot\*" -Destination $backendWwwroot -Recurse -Force
	Write-Host "Frontend files copied successfully to $backendWwwroot"

	# List copied files
	Get-ChildItem -Path $backendWwwroot -Recurse -File | ForEach-Object {
		Write-Host "  - $($_.FullName.Substring((Get-Location).Path.Length + 1))"
	}
} else {
	Write-Host "Frontend wwwroot not found at $frontendWwwroot"
	exit 1
}

Write-Host "`nFrontend assets preparation completed"
