# Test script for EpargneArgents API endpoints
# PowerShell version

$ApiBase = "http://localhost:5000"
$Endpoint = "/api/DailyContribution"

Write-Host "======================================"
Write-Host "EpargneArgents API Test Suite"
Write-Host "======================================"
Write-Host ""

# Check if API is running
Write-Host "Checking API availability..."
try {
	$response = Invoke-WebRequest -Uri $ApiBase -Method Get -ErrorAction Stop
	Write-Host "API is responding (Status: $($response.StatusCode))"
}
catch {
	Write-Host "API is not responding"
	Write-Host "Make sure the backend is running with: dotnet run"
	exit 1
}
Write-Host ""

# Test 1: POST with valid parameters
Write-Host "Test 1: POST with valid parameters"
Write-Host "-----------------------------------"
try {
	$body = @{
		totalAmount = 10000
		denominations = "5;10;20;50;60"
		numberDaysSaving = 365
	} | ConvertTo-Json

	$response = Invoke-WebRequest -Uri "$ApiBase$Endpoint" `
		-Method Post `
		-Headers @{"Content-Type"="application/json"} `
		-Body $body `
		-ErrorAction Stop

	Write-Host "PASSED - CSV file generated (Status: $($response.StatusCode))"
}
catch {
	Write-Host "Response: $($_.Exception.Message)"
}
Write-Host ""

# Test 2: POST with missing denominations
Write-Host "Test 2: POST with missing denominations"
Write-Host "----------------------------------------"
try {
	$body = @{
		totalAmount = 10000
		numberDaysSaving = 365
	} | ConvertTo-Json

	$response = Invoke-WebRequest -Uri "$ApiBase$Endpoint" `
		-Method Post `
		-Headers @{"Content-Type"="application/json"} `
		-Body $body `
		-ErrorAction Stop

	Write-Host "ERROR - Should have failed (Status: $($response.StatusCode))"
}
catch {
	if ($_.Exception.Response.StatusCode -eq "BadRequest") {
		Write-Host "PASSED - Returns 400 Bad Request"
	}
	else {
		Write-Host "Got status: $($_.Exception.Response.StatusCode)"
	}
}
Write-Host ""

# Test 3: POST with invalid total amount
Write-Host "Test 3: POST with invalid total amount"
Write-Host "----------------------------------------"
try {
	$body = @{
		totalAmount = 0
		denominations = "5;10;20;50;60"
		numberDaysSaving = 365
	} | ConvertTo-Json

	$response = Invoke-WebRequest -Uri "$ApiBase$Endpoint" `
		-Method Post `
		-Headers @{"Content-Type"="application/json"} `
		-Body $body `
		-ErrorAction Stop

	Write-Host "ERROR - Should have failed (Status: $($response.StatusCode))"
}
catch {
	if ($_.Exception.Response.StatusCode -eq "BadRequest") {
		Write-Host "PASSED - Returns 400 Bad Request"
	}
	else {
		Write-Host "Got status: $($_.Exception.Response.StatusCode)"
	}
}
Write-Host ""

# Test 4: Frontend loads
Write-Host "Test 4: Frontend loads"
Write-Host "---------------------"
try {
	$response = Invoke-WebRequest -Uri $ApiBase -Method Get -ErrorAction Stop
	Write-Host "PASSED - Frontend accessible (Status: $($response.StatusCode))"
}
catch {
	Write-Host "ERROR - Frontend not accessible"
}
Write-Host ""

# Test 5: Swagger documentation
Write-Host "Test 5: Swagger documentation"
Write-Host "------------------------------"
try {
	$response = Invoke-WebRequest -Uri "$ApiBase/swagger" -Method Get -ErrorAction Stop
	Write-Host "PASSED - Swagger docs available (Status: $($response.StatusCode))"
}
catch {
	if ($_.Exception.Response.StatusCode -eq "Redirect" -or $_.Exception.Response.StatusCode -eq "MovedPermanently") {
		Write-Host "PASSED - Swagger docs available (Redirected)"
	}
	else {
		Write-Host "Swagger returned: $($_.Exception.Response.StatusCode)"
	}
}
Write-Host ""

# Test 6: GET request (should fail - POST only)
Write-Host "Test 6: GET request (should fail)"
Write-Host "---------------------------------"
try {
	$response = Invoke-WebRequest -Uri "$ApiBase$Endpoint" -Method Get -ErrorAction Stop
	Write-Host "ERROR - Should have failed (Status: $($response.StatusCode))"
}
catch {
	if ($_.Exception.Response.StatusCode -eq "MethodNotAllowed" -or $_.Exception.Response.StatusCode -eq "NotFound") {
		Write-Host "PASSED - Returns 405 Method Not Allowed or 404 Not Found"
	}
	else {
		Write-Host "Got status: $($_.Exception.Response.StatusCode)"
	}
}
Write-Host ""

Write-Host "======================================"
Write-Host "Test Suite Complete"
Write-Host "======================================"
