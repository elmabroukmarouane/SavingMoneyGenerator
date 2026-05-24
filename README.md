# EpargneArgents - Frontend & Backend Integration

## 📋 Overview

This repository now contains both the **frontend (Blazor WebAssembly)** and **backend (ASP.NET Core API)** integrated into a single solution.

### Project Structure

```
EpargneArgents-master/
├── EpargneArgents.API/              # Backend API (ASP.NET Core 10.0)
│   ├── Controllers/                 # API Controllers
│   ├── Models/                      # Data Models
│   ├── wwwroot/                     # Static files (frontend assets)
│   ├── appsettings.json             # Configuration
│   └── Program.cs                   # Application startup
│
├── EpargneArgents.Business/         # Business Logic Layer
│   ├── Services/                    # Business Services
│   └── Models/                      # Domain Models
│
├── EpargneArgents.Client.Web/       # Frontend (Blazor WebAssembly)
│   ├── Pages/                       # Razor Pages
│   ├── Components/                  # Blazor Components
│   ├── Models/                      # Frontend Models
│   ├── Layout/                      # Layout Components
│   ├── wwwroot/                     # Static Assets
│   └── Program.cs                   # Frontend Configuration
│
└── EpargneArgents.sln               # Solution File
```

## 🚀 Features

### Backend (API)
- **ASP.NET Core 10.0** Web API
- **Swagger/OpenAPI** documentation
- **CORS** support for frontend communication
- **CSV Generation Service** for daily contributions
- **Static Files Serving** for Blazor frontend

### Frontend (Client)
- **Blazor WebAssembly** application
- **Responsive Bootstrap 5** UI
- **SPA Routing** with Blazor Router
- **Daily Saving Money Calculator**
- **CSV File Generation & Download**

## 🛠️ Technologies

- **.NET 10.0** - Latest framework
- **ASP.NET Core** - Backend framework
- **Blazor WebAssembly** - Frontend framework
- **Bootstrap 5** - CSS Framework
- **Swagger** - API Documentation

## 🏗️ Building the Solution

### Prerequisites
- .NET 10.0 SDK
- Visual Studio 2026 or VS Code
- PowerShell or Bash shell

### Build Steps

1. **Restore NuGet packages:**
```bash
dotnet restore
```

2. **Build the solution:**
```bash
dotnet build
```

3. **Prepare frontend assets (for publishing):**
```powershell
# Windows PowerShell
.\prepare-frontend.ps1

# Or Bash
bash ./prepare-frontend.sh
```

4. **Run the backend API:**
```bash
cd EpargneArgents.API
dotnet run
```

The API will be available at: `https://localhost:5001` (HTTPS) or `http://localhost:5000` (HTTP)
The frontend will be served at: `http://localhost:5000/`

## 📚 API Endpoints

### Daily Contribution Generator

**POST** `/api/DailyContribution`

**Request Body:**
```json
{
  "totalAmount": 10000,
  "denominations": "5;10;20;50;60",
  "numberDaysSaving": 365
}
```

**Response:** CSV file download

**Alternative:** Use configuration defaults from `appsettings.json`
```
POST /api/DailyContribution
```

## ⚙️ Configuration

### Backend Configuration (`appsettings.json`)

```json
{
  "Parameters": {
	"Denominations": "5;10;20;50;60",
	"TotalAmount": 10000,
	"NumberDaysSaving": 365,
	"CsvFileName": "DailyContributionCsvFile"
  },
  "CorsName": "CORSPOLICYSTRINGEPARGNEARGENTAPPAPI"
}
```

### Frontend Configuration (`appsettings.json`)

```json
{
  "ApiBaseAddress": ""
}
```
- Empty string = Use same origin as frontend
- Or specify full URL for API

## 🚢 Publishing

### Publish the combined solution:

```bash
# Build frontend and backend
dotnet publish -c Release

# Or publish only the API (includes frontend assets)
cd EpargneArgents.API
dotnet publish -c Release -o ./publish
```

The published application will include:
- Backend API executable
- Frontend static assets (HTML, CSS, JS, WASM)
- All configurations

## 🧪 Testing

### Test the API:

```bash
# Using curl
curl -X POST http://localhost:5000/api/DailyContribution \
  -H "Content-Type: application/json" \
  -d '{"totalAmount":10000,"denominations":"5;10;20;50;60","numberDaysSaving":365}'

# Or visit Swagger UI
http://localhost:5000/swagger
```

### Test the Frontend:

Visit `http://localhost:5000/` in your browser

1. Navigate to "Saving Generator" page
2. Enter parameters (or use defaults)
3. Click "Generate CSV"
4. CSV file will download automatically

## 🔄 Workflow

### Development

1. **Backend changes:**
   - Edit API code in `EpargneArgents.API/`
   - Run `dotnet run` to test

2. **Frontend changes:**
   - Edit Razor components in `EpargneArgents.Client.Web/`
   - Browser will auto-refresh (if using DevServer)

3. **Build & Test:**
   - `dotnet build` to verify compilation
   - Run integration tests

### Publishing

1. **Prepare frontend assets:**
   ```powershell
   .\prepare-frontend.ps1
   ```

2. **Publish the API:**
   ```bash
   cd EpargneArgents.API
   dotnet publish -c Release
   ```

3. **Deploy:**
   - Copy published files to server
   - Configure appsettings for production
   - Run the API application

## 📝 File Descriptions

### Backend Improvements

- **Program.cs** - Enhanced with static files serving, SPA routing fallback
- **DailyContributionController.cs** - Improved error handling, validation, documentation
- **appsettings.json** - Centralized configuration

### Frontend Improvements

- **SavingMoneyCsvGenerator.razor** - Better error handling, loading states, form validation
- **Parameters.cs** - Added data annotations for validation
- **Program.cs** - Configurable API base address
- **index.html** - Improved metadata and title
- **app.js** - File download utility function

## 🐛 Troubleshooting

### CORS Issues
- Ensure CORS policy is enabled in `Program.cs`
- Check `appsettings.json` CorsName configuration
- Frontend must use correct API URL

### Static Files Not Serving
- Ensure `prepare-frontend.ps1` was run
- Check that `EpargneArgents.API/wwwroot/` contains frontend files
- Verify `UseDefaultFiles()` and `UseStaticFiles()` are called in `Program.cs`

### API Not Found
- Check that backend is running on correct port
- Verify API endpoint matches frontend request URL
- Check firewall/security settings

## 📚 Additional Resources

- [Blazor Documentation](https://learn.microsoft.com/aspnet/core/blazor/)
- [ASP.NET Core Documentation](https://learn.microsoft.com/aspnet/core/)
- [Bootstrap Documentation](https://getbootstrap.com/docs)

## 📄 License

[Add your license information here]

## 👥 Contributors

- Backend Developer (Senior .NET 10)
- Frontend Developer

---

**Last Updated:** May 25, 2026
**Framework Version:** .NET 10.0
