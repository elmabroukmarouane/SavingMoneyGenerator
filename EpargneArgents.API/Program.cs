using EpargneArgents.Business.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddSingleton(builder.Configuration);
builder.Services.AddTransient<IGenerateRandomDailyContribution, GenerateRandomDailyContribution>();

// Configure CORS to allow frontend requests
builder.Services.AddCors(options =>
{
    var corsPolicy = builder.Configuration.GetSection("CorsName").Value ?? "AllowAll";
    options.AddPolicy(corsPolicy,
        policy => policy
            .AllowAnyOrigin()
            .AllowAnyMethod()
            .AllowAnyHeader()
            .SetIsOriginAllowed(origin => true)
    );
});

var app = builder.Build();

// Configure the HTTP request pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// Enable CORS
var corsPolicy = builder.Configuration.GetSection("CorsName").Value ?? "AllowAll";
app.UseCors(corsPolicy);

// Configure static files (for Blazor frontend)
app.UseDefaultFiles(); // Serve index.html by default
app.UseStaticFiles();

// Map API controllers
app.UseRouting();
app.UseAuthorization();

app.MapControllers();

// Fallback route for Blazor frontend (SPA routing)
app.MapFallbackToFile("index.html");

await app.RunAsync();
