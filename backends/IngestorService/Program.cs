using System.Text;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using StackExchange.Redis;
using Npgsql;

var builder = WebApplication.CreateBuilder(args);

// 1. Load Configuration
var jwtSecret = builder.Configuration["Jwt:Secret"] ?? "super_secret_key_change_me_in_prod_12345";
var redisConn = builder.Configuration["Redis:Connection"] ?? "localhost:6379";
var dbConn = builder.Configuration.GetConnectionString("DefaultConnection") ?? "Host=localhost;Database=attendance_logs;Username=forge;Password=forge_secret";

// 2. Add Services (DI)
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// 3. Configure Redis (High Performance Cache)
// Singleton is recommended for ConnectionMultiplexer
builder.Services.AddSingleton<IConnectionMultiplexer>(sp => 
    ConnectionMultiplexer.Connect(redisConn));

// 4. Configure Authentication (JWT)
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = false, // Internal issuer
            ValidateAudience = false, // Internal audience
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSecret)),
            ClockSkew = TimeSpan.Zero
        };
    });

// 5. Configure HttpClient (For Forwarding to Laravel / FastAPI)
builder.Services.AddHttpClient("LaravelCore", client =>
{
    client.BaseAddress = new Uri(builder.Configuration["Services:LaravelUrl"] ?? "http://localhost:8000/api/");
});

builder.Services.AddHttpClient("AIEngine", client =>
{
    client.BaseAddress = new Uri(builder.Configuration["Services:AIUrl"] ?? "http://localhost:8001/");
});

// 6. CORS (Allow Flutter)
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll",
        b => b.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader());
});

var app = builder.Build();

// -----------------------------------------------------------------------------
// REQUEST PIPELINE
// -----------------------------------------------------------------------------

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowAll");

app.UseAuthentication();
app.UseAuthorization();

// Health Check
app.MapGet("/", () => 
    Results.Ok(new { Service = "TalentForge .NET Gateway", Status = "Online", Timestamp = DateTime.UtcNow }));

// Example: Attendance Ingestion (High Speed)
app.MapPost("/api/v1/attendance/check-in", async (IConnectionMultiplexer redis, HttpContext ctx) =>
{
    // 1. Fast Auth Check (Claims)
    // 2. Push to Redis Stream or Queue immediately
    var db = redis.GetDatabase();
    // await db.StreamAddAsync("attendance_stream", ...);
    
    return Results.Accepted(value: new { message = "Check-in received", traceId = ctx.TraceIdentifier });
})
.RequireAuthorization(); // JWT Required

app.MapControllers();

app.Run();
