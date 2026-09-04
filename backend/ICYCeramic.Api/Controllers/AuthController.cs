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
}