using ICYCeramic.Api.Data;
using ICYCeramic.Api.Models;
using ICYCeramic.Api.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ICYCeramic.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public AuthController(ApplicationDbContext context)
    {
        _context = context;
    }

    // ============================================================
    // KAYIT OL
    // ============================================================

    [HttpPost("register")]
    public async Task<IActionResult> Register(
        [FromBody] RegisterRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.Name))
        {
            return BadRequest(new
            {
                message = "Ad soyad alanı zorunludur."
            });
        }

        if (string.IsNullOrWhiteSpace(request.Email))
        {
            return BadRequest(new
            {
                message = "E-posta alanı zorunludur."
            });
        }

        if (string.IsNullOrWhiteSpace(request.Password))
        {
            return BadRequest(new
            {
                message = "Şifre alanı zorunludur."
            });
        }

        if (request.Password.Length < 6)
        {
            return BadRequest(new
            {
                message = "Şifre en az 6 karakter olmalıdır."
            });
        }

        string email = request.Email
            .Trim()
            .ToLowerInvariant();

        bool emailExists = await _context.Users
            .AnyAsync(user => user.Email == email);

        if (emailExists)
        {
            return Conflict(new
            {
                message = "Bu e-posta adresi zaten kayıtlı."
            });
        }

        var user = new User
        {
            Name = request.Name.Trim(),
            Email = email,
            PasswordHash = PasswordHasher.Hash(request.Password),
            CreatedAt = DateTime.UtcNow
        };

        _context.Users.Add(user);

        await _context.SaveChangesAsync();

        return Ok(new
        {
            message = "Kayıt başarılı.",
            userId = user.Id,
            name = user.Name,
            email = user.Email
        });
    }

    // ============================================================
    // GİRİŞ YAP
    // ============================================================

    [HttpPost("login")]
    public async Task<IActionResult> Login(
        [FromBody] LoginRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.Email))
        {
            return BadRequest(new
            {
                message = "E-posta alanı zorunludur."
            });
        }

        if (string.IsNullOrWhiteSpace(request.Password))
        {
            return BadRequest(new
            {
                message = "Şifre alanı zorunludur."
            });
        }

        string email = request.Email
            .Trim()
            .ToLowerInvariant();

        var user = await _context.Users
            .FirstOrDefaultAsync(
                user => user.Email == email
            );

        if (user == null)
        {
            return Unauthorized(new
            {
                message = "E-posta veya şifre hatalı."
            });
        }

        bool passwordCorrect = PasswordHasher.Verify(
            request.Password,
            user.PasswordHash
        );

        if (!passwordCorrect)
        {
            return Unauthorized(new
            {
                message = "E-posta veya şifre hatalı."
            });
        }

        return Ok(new
        {
            message = "Giriş başarılı.",
            userId = user.Id,
            name = user.Name,
            email = user.Email
        });
    }
}