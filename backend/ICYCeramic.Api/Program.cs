using ICYCeramic.Api.Data;
using ICYCeramic.Api.Seed;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Controller desteği
builder.Services.AddControllers();

// OpenAPI desteği
builder.Services.AddOpenApi();

// SQL Server + Entity Framework Core bağlantısı
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("DefaultConnection")
    )
);

var app = builder.Build();

// ============================================================
// VERİTABANI BAŞLANGIÇ VERİLERİ
// ============================================================

using (var scope = app.Services.CreateScope())
{
    var dbContext = scope.ServiceProvider
        .GetRequiredService<ApplicationDbContext>();

    DbInitializer.Initialize(dbContext);
}

// Geliştirme ortamında OpenAPI
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

// HTTPS yönlendirmesi
app.UseHttpsRedirection();

// Controller'ları aktif et
app.MapControllers();

app.Run();