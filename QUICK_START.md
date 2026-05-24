# Quick Start Guide

## 🚀 Running the Application

### Option 1: Automated Startup (Recommended)

**Windows:**
```bash
start.bat
```

This script will:
1. Check .NET installation ✅
2. Prepare frontend assets ✅
3. Build solution ✅
4. Start API on `http://localhost:5000` ✅

### Option 2: Manual Steps

**Step 1: Build the solution**
```bash
cd C:\Users\mel\source\repos\EpargneArgents-master
dotnet build
```

**Step 2: Prepare frontend assets**
```bash
powershell -ExecutionPolicy Bypass -File .\prepare-frontend.ps1
```

**Step 3: Run the API**
```bash
cd EpargneArgents.API
dotnet run
```

**Step 4: Open browser**
- Frontend: `http://localhost:5000/`
- API Swagger: `http://localhost:5000/swagger`

## 📝 Using the Application

### Home Page
1. Navigate to `http://localhost:5000/`
2. You'll see the home page with welcome message

### Saving Money Generator
1. Click "Saving Generator" in the navigation menu
2. Enter parameters:
   - **Total Amount:** 10000 (e.g., the total you want to save)
   - **Denominations:** 5;10;20;50;60 (semicolon-separated amounts per day)
   - **Number of days:** 365 (how many days to spread savings across)
3. Click "Generate CSV"
4. File will download automatically as `DailyContributionCsvFile.csv`

### Example Parameters
```
Total Amount: 10000
Denominations: 5;10;20;50;60
Number of Days: 365
```

This will generate a CSV with daily amounts to save that totals 10000 over 365 days.

## 🧪 Testing the API Directly

### Using Swagger UI
1. Visit: `http://localhost:5000/swagger`
2. Scroll to "DailyContribution" section
3. Click "Try it out"
4. Enter JSON parameters
5. Click "Execute"

### Using cURL

```bash
curl -X POST http://localhost:5000/api/DailyContribution \
  -H "Content-Type: application/json" \
  -d '{
	"totalAmount": 10000,
	"denominations": "5;10;20;50;60",
	"numberDaysSaving": 365
  }' \
  --output daily-contribution.csv
```

### Using PowerShell

```powershell
$body = @{
	totalAmount = 10000
	denominations = "5;10;20;50;60"
	numberDaysSaving = 365
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:5000/api/DailyContribution" `
  -Method Post `
  -Headers @{"Content-Type"="application/json"} `
  -Body $body `
  -OutFile "daily-contribution.csv"
```

## 📦 Project Structure

```
EpargneArgents-master/
├── EpargneArgents.API/           # Backend API
├── EpargneArgents.Business/      # Business logic
├── EpargneArgents.Client.Web/    # Frontend (Blazor)
└── *.md                           # Documentation
```

## 📚 Documentation Files

- **README.md** - Full project overview
- **INTEGRATION_GUIDE.md** - How frontend was integrated
- **DEPLOYMENT_GUIDE.md** - Production deployment
- **CODE_IMPROVEMENTS.md** - Code enhancements made
- **CHECKLIST.md** - Integration verification checklist

## 🐛 Troubleshooting

### Issue: Port 5000 already in use
```bash
# Find and kill process on port 5000
netstat -ano | findstr :5000
taskkill /PID <PID> /F
```

### Issue: Build fails
```bash
# Clean and rebuild
dotnet clean
dotnet restore
dotnet build
```

### Issue: Frontend assets not loading
```bash
# Regenerate frontend assets
powershell -ExecutionPolicy Bypass -File .\prepare-frontend.ps1
```

### Issue: API endpoint returns 404
- Check backend is running (`http://localhost:5000/swagger` should load)
- Verify correct endpoint: `POST /api/DailyContribution`
- Check browser console for CORS errors

### Issue: CSV download doesn't work
- Check browser console for JavaScript errors
- Verify `wwwroot/js/app.js` is loaded
- Check that backend returns correct Content-Type header

## ⚙️ Configuration

### API Configuration (`EpargneArgents.API/appsettings.json`)

```json
{
  "Parameters": {
	"Denominations": "5;10;20;50;60",
	"TotalAmount": 10000,
	"NumberDaysSaving": 365,
	"CsvFileName": "DailyContributionCsvFile"
  }
}
```

To change defaults, edit these values.

### Frontend Configuration (`EpargneArgents.Client.Web/appsettings.json`)

```json
{
  "ApiBaseAddress": ""
}
```

- Empty string = Use same origin (recommended)
- Or set to specific URL: `"http://api.example.com"`

## 🚢 Deployment

### Quick Docker Deployment

```bash
# Build Docker image
docker build -t epargneargents:latest .

# Run container
docker run -p 5000:5000 epargneargents:latest

# Or with Docker Compose
docker-compose up
```

Visit: `http://localhost:5000`

### See DEPLOYMENT_GUIDE.md for:
- Azure App Service deployment
- IIS deployment
- Linux/Systemd deployment
- Kubernetes deployment
- Production configuration

## 🔍 Health Check

Run the health check script:

```bash
health-check.bat
```

This verifies:
- ✅ API is responding
- ✅ Swagger docs available
- ✅ Frontend is accessible

## 📞 Support

- **Backend API Issues:** Check `EpargneArgents.API/` logs
- **Frontend Issues:** Check browser developer console (F12)
- **Build Issues:** Run `dotnet clean && dotnet build`
- **Port Issues:** Use `netstat` to find process on port 5000

## 📋 File Operations

### Generate CSV via API

**Request:**
```
POST /api/DailyContribution
Content-Type: application/json

{
  "totalAmount": 10000,
  "denominations": "5;10;20;50;60",
  "numberDaysSaving": 365
}
```

**Response:**
```
Content-Type: text/csv
Content-Disposition: attachment; filename="DailyContributionCsvFile.csv"

date,amount
2024-01-01,20
2024-01-02,60
...
```

**CSV Output Location:**
- Generated files stored in: `GeneratedCsvOutputFolder/`
- Filename configurable via appsettings.json

## 🎓 Learning Resources

- [Blazor Documentation](https://learn.microsoft.com/aspnet/core/blazor/)
- [ASP.NET Core Docs](https://learn.microsoft.com/aspnet/core/)
- [Bootstrap Docs](https://getbootstrap.com/)
- [.NET 10 Features](https://learn.microsoft.com/en-us/dotnet/whats-new/dotnet-10)

## ✅ Verification Checklist

After running `start.bat`:

- [ ] No build errors in console
- [ ] "Application started successfully" message
- [ ] Can visit `http://localhost:5000/`
- [ ] Frontend page loads
- [ ] Navigation menu visible
- [ ] Can navigate to "Saving Generator"
- [ ] Can enter parameters
- [ ] Can click "Generate CSV"
- [ ] CSV file downloads
- [ ] File opens correctly in Excel/spreadsheet app

## 🎉 Success!

If all checks pass, you're ready to:
- Develop new features
- Test the application
- Deploy to production
- Share with users

---

**Framework:** .NET 10.0
**Last Updated:** May 25, 2026
**Status:** ✅ Ready to Use
