# Build stage
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build

WORKDIR /source

# Copy solution and project files
COPY ["EpargneArgents.sln", "."]
COPY ["EpargneArgents.API/", "EpargneArgents.API/"]
COPY ["EpargneArgents.Business/", "EpargneArgents.Business/"]
COPY ["EpargneArgents.Client.Web/", "EpargneArgents.Client.Web/"]

# Restore dependencies
RUN dotnet restore "EpargneArgents.sln"

# Publish
RUN dotnet publish "EpargneArgents.API/EpargneArgents.API.csproj" -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime

WORKDIR /app

# Install curl for health checks
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

COPY --from=build /app/publish .

# Create directory for CSV output
RUN mkdir -p GeneratedCsvOutputFolder

# Expose ports
EXPOSE 5000 5001

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
	CMD curl -f http://localhost:5000/ || exit 1

# Set environment
ENV ASPNETCORE_URLS=http://+:5000;https://+:5001
ENV ASPNETCORE_ENVIRONMENT=Production

# Start application
ENTRYPOINT ["dotnet", "EpargneArgents.API.dll"]
