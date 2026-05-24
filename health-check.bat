@echo off
REM Health check script for EpargneArgents API

echo ====================================
echo EpargneArgents API Health Check
echo ====================================
echo.

REM Check if API is running
echo Checking API availability...
curl -s http://localhost:5000/api/DailyContribution -X OPTIONS -w "HTTP Status: %%{http_code}\n" > nul 2>&1

if %ERRORLEVEL% equ 0 (
	echo [OK] API is responding
) else (
	echo [FAIL] API is not responding
	exit /b 1
)

REM Check Swagger documentation
echo.
echo Checking Swagger documentation...
curl -s -o nul -w "HTTP Status: %%{http_code}\n" http://localhost:5000/swagger/index.html | find "200" > nul

if %ERRORLEVEL% equ 0 (
	echo [OK] Swagger docs available
) else (
	echo [WARN] Swagger docs not available
)

REM Check frontend
echo.
echo Checking frontend...
curl -s -o nul -w "HTTP Status: %%{http_code}\n" http://localhost:5000/ | find "200" > nul

if %ERRORLEVEL% equ 0 (
	echo [OK] Frontend is accessible
) else (
	echo [FAIL] Frontend is not accessible
	exit /b 1
)

echo.
echo ====================================
echo All checks passed!
echo ====================================

exit /b 0
