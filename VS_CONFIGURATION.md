# EpargneArgents VS Configuration

This file contains recommended Visual Studio settings and extensions for the EpargneArgents project.

## Recommended Visual Studio Extensions

### Productivity
- **C# Dev Kit** - Modern C# development tools
- **Visual Studio IntelliCode** - AI-powered code suggestions
- **Prettier** - Code formatter
- **EditorConfig Language Service** - EditorConfig support

### Web Development
- **Web Compiler** - Compile SCSS/LESS
- **Bootstrap Intellisense** - Bootstrap CSS suggestions
- **Live Share** - Collaborative development

### API Development
- **REST Client** - Test REST APIs
- **Swagger Viewer** - View OpenAPI/Swagger documentation
- **Thunder Client** - HTTP client for testing

### Documentation
- **Markdown Editor** - Better markdown editing
- **Markdown Preview Enhanced** - Enhanced preview

### Git & DevOps
- **GitHub Copilot** - AI code completion
- **Azure Tools** - Azure integration
- **Docker** - Docker support

## Recommended Settings

### Editor Settings
```
Font: Cascadia Code (Recommended)
Size: 12pt
Theme: Dark (Default)
Line Numbers: On
Minimap: On
Word Wrap: On
```

### Code Analysis
```
Enable: Code Analysis
Rules: Microsoft.CodeAnalysis.NetAnalyzers
Severity: Warning
```

### Formatting
```
Line Length: 120
Use Spaces: Yes
Indent Size: 4
Tab Size: 4
```

### Build & Debug
```
Configuration: Debug
Platform: Any CPU
Auto-build: Enabled
Just My Code: On (for debugging)
Break All: Off
```

## Launch Configuration

### Run API (Debug)
```
Project: EpargneArgents.API
Profile: http
Port: 5000
Environment: Development
```

### Debug Debugging
- Enable source link: Yes
- Download symbols: Yes
- Enable just my code: Yes

## Testing Configuration

### Unit Testing
```
Adapter: xUnit (recommended for .NET Core)
Test Timeout: 5000ms
Parallel Execution: On
```

### Code Coverage
```
Collect: On
Include: Source code
Exclude: Test projects
Thresholds: 70%
```

## Performance Monitoring

### Profiler Settings
```
CPU Sampling: On
Memory Allocation: On
.NET Object Allocation: On
```

### Diagnostic Tools
- Breakpoints: Conditional
- Watch Windows: Enabled
- Immediate Window: Enabled

## Web Development Settings

### Browser Tools
```
Default Browser: Chrome
Debugging: F12 Developer Tools
Breakpoints in JS: Enabled
```

### IIS Express
```
Port: 5000
SSL: Optional
Module: AspNetCoreModule

## Project Templates

For new components, use these templates:

### C# Files
- Class: Standard class
- Interface: Public interface
- Record: For data classes

### Razor Components
- Razor Component (.razor)
- Blazor Page (.razor)

## Git Configuration

### Branch Strategy
```
Main: Production
Develop: Development
Feature: feature/feature-name
Release: release/version-name
Hotfix: hotfix/issue-name
```

### Commit Message Format
```
[TYPE]: Description

Types:
  feat: New feature
  fix: Bug fix
  docs: Documentation
  style: Code style
  refactor: Code refactoring
  test: Tests
  chore: Maintenance
  ci: CI/CD
```

## Recommended Keyboard Shortcuts

```
Build Solution .......................... Ctrl+Shift+B
Debug Project ........................... F5
Run Without Debug ....................... Ctrl+F5
Stop Debugger ........................... Shift+F5
Step Into ............................... F11
Step Over ............................... F10
Continue ................................ F5
Set Breakpoint .......................... F9
Toggle Breakpoint ....................... Ctrl+B
Clear All Breakpoints ................... Ctrl+Shift+F9
Watch Window ............................. Ctrl+Alt+W, 1
Immediate Window ......................... Ctrl+Alt+I
Solution Explorer ....................... Ctrl+Alt+L
Output Window ........................... Ctrl+Alt+O
Errors List .............................. Ctrl+\\, Ctrl+E
```

## Code Snippets

Create these snippets in Visual Studio:

### async Task
```
ati
↓
public async Task InitializeAsync()
{
	await Task.Delay(0);
}
```

### try-catch-finally
```
tryf
↓
try
{

}
catch (Exception ex)
{

}
finally
{

}
```

## Useful Commands

### Package Manager Console
```powershell
# Update NuGet packages
Update-Package

# Restore packages
Update-Package -Reinstall

# Add migration
Add-Migration MigrationName

# Update database
Update-Database
```

## Solution Structure Best Practices

```
EpargneArgents-master/
├── 📁 EpargneArgents.API
│   ├── Controllers/
│   ├── Models/
│   └── Services/
├── 📁 EpargneArgents.Business
│   ├── Services/
│   └── Models/
├── 📁 EpargneArgents.Client.Web
│   ├── Pages/
│   ├── Components/
│   ├── Models/
│   └── wwwroot/
└── 📁 Tests (when added)
	├── EpargneArgents.Tests/
	└── EpargneArgents.Integration.Tests/
```

## Performance Tips

1. **Use Release Build** for performance testing
2. **Enable Code Analysis** to catch issues early
3. **Profile regularly** using Diagnostic Tools
4. **Check Memory** for leaks
5. **Monitor CPU** for bottlenecks

## Common Issues & Solutions

### Build Fails
- Clean solution (Build > Clean Solution)
- Restore NuGet packages
- Check .NET SDK version

### IntelliSense Not Working
- Close and reopen file
- Rebuild solution
- Restart Visual Studio

### Debugging Issues
- Clear breakpoints
- Delete bin/obj folders
- Full rebuild

## Additional Resources

- [Visual Studio Docs](https://docs.microsoft.com/visualstudio/)
- [C# Documentation](https://docs.microsoft.com/dotnet/csharp/)
- [ASP.NET Core Docs](https://docs.microsoft.com/aspnet/core/)
- [Blazor Docs](https://docs.microsoft.com/aspnet/core/blazor/)

---

**Last Updated:** May 25, 2026
**VS Version:** 2026
**Framework:** .NET 10.0
