using System.Text;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using StackExchange.Redis;
using Npgsql;
using System.Net.Http.Headers;

var builder = WebApplication.CreateBuilder(args);

// 1. Load Configuration
var jwtSecret = builder.Configuration["Jwt:Secret"] ?? "super_secret_key_change_me_in_prod_12345";
var redisConn = builder.Configuration["Redis:Connection"] ?? "localhost:6379";
var dbConn = builder.Configuration.GetConnectionString("DefaultConnection") ?? "Host=localhost;Database=attendance_logs;Username=forge;Password=forge_secret";

// 2. Add Services (DI)
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// 3. Configure Redis
try {
    builder.Services.AddSingleton<IConnectionMultiplexer>(sp => ConnectionMultiplexer.Connect(redisConn));
} catch (Exception ex) {
    Console.WriteLine($"Redis connection failed: {ex.Message}");
}

// 4. Configure Authentication (JWT)
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = false,
            ValidateAudience = false, 
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSecret)),
            ClockSkew = TimeSpan.Zero
        };
    });

// 5. Configure HttpClients
builder.Services.AddHttpClient("LaravelCore", client =>
{
    client.BaseAddress = new Uri(builder.Configuration["Services:LaravelUrl"] ?? "http://business:8000/api/");
});

builder.Services.AddHttpClient("AIEngine", client =>
{
    client.BaseAddress = new Uri(builder.Configuration["Services:AIUrl"] ?? "http://ai-engine:8000/");
});

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFlutter",
        b => b.WithOrigins("http://localhost:3000", "http://localhost:8000") // Add production domains here
              .AllowAnyMethod()
              .AllowAnyHeader());
});

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowFlutter");
// app.UseAuthentication(); 

// DB Health Check Endpoint (To use dbConn)
app.MapGet("/health", async () => {
    try {
        using var conn = new NpgsqlConnection(dbConn);
        await conn.OpenAsync();
        return Results.Ok(new { Database = "Connected", Gateway = "Online" });
    } catch (Exception ex) {
        return Results.Problem($"Database connection failed: {ex.Message}");
    }
});

// -----------------------------------------------------------------------------
// PROXY LOGIC
// -----------------------------------------------------------------------------

// Helper to forward requests
async Task ForwardRequest(HttpContext context, string clientName, string upstreamPath)
{
    var httpClientFactory = context.RequestServices.GetRequiredService<IHttpClientFactory>();
    var client = httpClientFactory.CreateClient(clientName);

    var requestMessage = new HttpRequestMessage();
    var requestMethod = context.Request.Method;
    
    // Copy content (if any)
    if (!HttpMethods.IsGet(requestMethod) &&
        !HttpMethods.IsHead(requestMethod) &&
        !HttpMethods.IsDelete(requestMethod) &&
        !HttpMethods.IsTrace(requestMethod))
    {
        var streamContent = new StreamContent(context.Request.Body);
        requestMessage.Content = streamContent;
        // Copy content headers
        foreach (var header in context.Request.Headers)
        {
             // Rough copy
             // In prod, check Content-Type etc.
             if(header.Key.StartsWith("Content-")) {
                 requestMessage.Content.Headers.TryAddWithoutValidation(header.Key, header.Value.ToArray());
             }
        }
    }

    // Copy Request Headers
    foreach (var header in context.Request.Headers)
    {
        if(!header.Key.StartsWith("Content-")) {
            requestMessage.Headers.TryAddWithoutValidation(header.Key, header.Value.ToArray());
        }
    }

    requestMessage.RequestUri = new Uri(client.BaseAddress! + upstreamPath);
    requestMessage.Method = new HttpMethod(requestMethod);

    try 
    {
        var responseMessage = await client.SendAsync(requestMessage, HttpCompletionOption.ResponseHeadersRead, context.RequestAborted);
        
        context.Response.StatusCode = (int)responseMessage.StatusCode;
        foreach (var header in responseMessage.Headers)
        {
            context.Response.Headers[header.Key] = header.Value.ToArray();
        }
        
        foreach (var header in responseMessage.Content.Headers)
        {
            context.Response.Headers[header.Key] = header.Value.ToArray();
        }

        // Send Async
        await responseMessage.Content.CopyToAsync(context.Response.Body);
    }
    catch (HttpRequestException ex)
    {
        context.Response.StatusCode = 503;
        await context.Response.WriteAsJsonAsync(new { error = "Service Unavailable", details = ex.Message });
    }
}

// 1. AI Routes -> FastAPI
app.MapMethods("/api/v1/ai/{*path}", 
    new[] { "GET", "POST", "PUT", "DELETE" }, 
    async (HttpContext context, string path) => 
    {
        // Target: /predict/anomaly etc. (Strip /api/v1/ai/)
        // Actually Program.cs maps /api/v1/ai -> upstream
        // If upstream is http://ai-engine:8000/
        // We want http://ai-engine:8000/predict/anomaly
        // So path is "anomalies" -> map "anomalies" to "predict/anomaly"? 
        // Or just forward cleanly.
        
        // Let's assume frontend calls /api/v1/ai/predict/anomaly
        await ForwardRequest(context, "AIEngine", path); 
    });

// 2. Core Business Routes -> Laravel
// Catch-all for /api/v1/{everything else}
app.MapMethods("/api/v1/{*path}", 
    new[] { "GET", "POST", "PUT", "DELETE" }, 
    async (HttpContext context, string path) => 
    {
        // Context: /api/v1/auth/login
        // Path matches: auth/login
        // Upstream Laravel Base: http://business:8000/api/
        // Result: http://business:8000/api/auth/login
        await ForwardRequest(context, "LaravelCore", path); 
    });

// Health Check
app.MapGet("/", () => Results.Ok(new { Service = "TalentForge .NET Gateway", Status = "Online" }));

app.Run();
