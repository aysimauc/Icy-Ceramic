using ICYCeramic.Api.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ICYCeramic.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class UsersController : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public UsersController(ApplicationDbContext context)
    {
        _context = context;
    }

    // ============================================================
    // TÜM KULLANICILARI GETİR
    // GET: api/users/admin
    // ============================================================

    [HttpGet("admin")]
    public async Task<IActionResult> GetAllUsers()
    {
        var users = await _context.Users
            .AsNoTracking()
            .OrderByDescending(
                user => user.CreatedAt)
            .Select(user => new
            {
                id = user.Id,
                name = user.Name,
                email = user.Email,
                role = user.Role,
                createdAt = user.CreatedAt
            })
            .ToListAsync();

        return Ok(users);
    }

    // ============================================================
    // TEK KULLANICIYI GETİR
    // GET: api/users/admin/1
    // ============================================================

    [HttpGet("admin/{id:int}")]
    public async Task<IActionResult> GetUser(int id)
    {
        var user = await _context.Users
            .AsNoTracking()
            .Where(user => user.Id == id)
            .Select(user => new
            {
                id = user.Id,
                name = user.Name,
                email = user.Email,
                role = user.Role,
                createdAt = user.CreatedAt
            })
            .FirstOrDefaultAsync();

        if (user == null)
        {
            return NotFound(new
            {
                message = "Kullanıcı bulunamadı."
            });
        }

        return Ok(user);
    }

    // ============================================================
    // KULLANICI ROLÜNÜ GÜNCELLE
    // PUT: api/users/1/role
    // ============================================================

    [HttpPut("{id:int}/role")]
    public async Task<IActionResult> UpdateUserRole(
        int id,
        [FromBody] UpdateUserRoleRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.Role))
        {
            return BadRequest(new
            {
                message =
                    "Kullanıcı rolü boş olamaz."
            });
        }

        var allowedRoles = new[]
        {
            "Customer",
            "Admin"
        };

        var newRole = request.Role.Trim();

        if (!allowedRoles.Contains(newRole))
        {
            return BadRequest(new
            {
                message =
                    "Geçersiz kullanıcı rolü."
            });
        }

        var user = await _context.Users
            .FirstOrDefaultAsync(
                user => user.Id == id);

        if (user == null)
        {
            return NotFound(new
            {
                message =
                    "Kullanıcı bulunamadı."
            });
        }

        user.Role = newRole;

        await _context.SaveChangesAsync();

        return Ok(new
        {
            message =
                "Kullanıcı rolü başarıyla güncellendi.",
            userId = user.Id,
            name = user.Name,
            email = user.Email,
            role = user.Role
        });
    }
}

// ================================================================
// ROLE REQUEST
// ================================================================

public class UpdateUserRoleRequest
{
    public string Role { get; set; } =
        string.Empty;
}