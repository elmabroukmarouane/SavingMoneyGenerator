@echo off
REM Start script for EpargneArgents solution

setlocal enabledelayedexpansion

echo ====================================
echo EpargneArgents - Full Stack Start
echo ====================================
echo.

REM Check .NET installation
echo Checking .NET SDK...
dotnet --version > nul 2>&1
if %ERRORLEVEL% NEQ 0 (
	echo [ERROR] .NET SDK not found. Please install .NET 10.0 SDK.
	exit /b 1
)
echo [OK] .NET SDK found

REM Check if frontend assets are prepared
echo.
echo Checking frontend assets...
if not exist "EpargneArgents.API\wwwroot\index.html" (
	echo [WARN] Frontend assets not found. Running preparation script...
	powershell -ExecutionPolicy Bypass -File .\prepare-frontend.ps1
	if !ERRORLEVEL! NEQ 0 (
		echo [ERROR] Failed to prepare frontend assets.
		exit /b 1
	)
)
echo [OK] Frontend assets ready

REM Build solution
echo.
echo Building solution...
dotnet build
if %ERRORLEVEL% NEQ 0 (
	echo [ERROR] Build failed.
	exit /b 1
)
echo [OK] Build successful

REM Start API
echo.
echo ====================================
echo Starting API on http://localhost:5000
echo ====================================
echo Frontend will be available at: http://localhost:5000/
echo Swagger docs at: http://localhost:5000/swagger
echo.
cd EpargneArgents.API
dotnet run

endlocal
