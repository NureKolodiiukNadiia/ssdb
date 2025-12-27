using Ssdb;

using Microsoft.Data.SqlClient;

var cs =
    "Server=127.0.0.1,14337;" +
    "Database=master;" +
    "User Id=sa;" +
    "Password=YourStrong!Passw0rd;" +
    "Encrypt=True;" +
    "TrustServerCertificate=True;";

using var conn = new SqlConnection(cs);
await conn.OpenAsync();

Console.WriteLine("CONNECTED");


var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAllOrigins", policy =>
    {
        policy.AllowAnyOrigin()
            .AllowAnyHeader()
            .AllowAnyMethod();
    });
});
builder.Services.AddControllers();
builder.Services.AddTransient<DataProvider>();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowAllOrigins");

app.UseHttpsRedirection();
app.MapControllers();
app.Run();
