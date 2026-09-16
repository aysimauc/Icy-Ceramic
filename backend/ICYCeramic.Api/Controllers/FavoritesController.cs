using ICYCeramic.Api.Data;
using ICYCeramic.Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ICYCeramic.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class FavoritesController : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public FavoritesController(ApplicationDbContext context)
    {
        _context = context;
    }

    // ============================================================
    // GET: api/favorites/user/{userId}
    // ============================================================

    [HttpGet("user/{userId:int}")]
    public async Task<IActionResult> GetUserFavorites(int userId)
    {
        var userExists = await _context.Users
            .AnyAsync(user => user.Id == userId);

        if (!userExists)
        {
            return NotFound(new
            {
                message = "Kullanıcı bulunamadı."
            });
        }

        var favorites = await _context.Favorites
            .Where(favorite => favorite.UserId == userId)
            .OrderByDescending(favorite => favorite.CreatedAt)
            .Select(favorite => new
            {
                id = favorite.Id,
                userId = favorite.UserId,
                productId = favorite.ProductId,
                createdAt = favorite.CreatedAt
            })
            .ToListAsync();

        return Ok(favorites);
    }

    // ============================================================
    // POST: api/favorites
    // ============================================================

    [HttpPost]
    public async Task<IActionResult> AddFavorite(
        [FromBody] FavoriteRequest request)
    {
        var userExists = await _context.Users
            .AnyAsync(user => user.Id == request.UserId);

        if (!userExists)
        {
            return NotFound(new
            {
                message = "Kullanıcı bulunamadı."
            });
        }

        var productExists = await _context.Products
            .AnyAsync(product => product.Id == request.ProductId);

        if (!productExists)
        {
            return NotFound(new
            {
                message = "Ürün bulunamadı."
            });
        }

        var alreadyExists = await _context.Favorites
            .AnyAsync(favorite =>
                favorite.UserId == request.UserId &&
                favorite.ProductId == request.ProductId);

        if (alreadyExists)
        {
            return Ok(new
            {
                message = "Ürün zaten favorilerde."
            });
        }

        var favorite = new Favorite
        {
            UserId = request.UserId,
            ProductId = request.ProductId,
            CreatedAt = DateTime.UtcNow
        };

        _context.Favorites.Add(favorite);

        await _context.SaveChangesAsync();

        return Ok(new
        {
            message = "Ürün favorilere eklendi.",
            id = favorite.Id
        });
    }

    // ============================================================
    // DELETE: api/favorites/{userId}/{productId}
    // ============================================================

    [HttpDelete("{userId:int}/{productId:int}")]
    public async Task<IActionResult> RemoveFavorite(
        int userId,
        int productId)
    {
        var favorite = await _context.Favorites
            .FirstOrDefaultAsync(item =>
                item.UserId == userId &&
                item.ProductId == productId);

        if (favorite == null)
        {
            return NotFound(new
            {
                message = "Favori kaydı bulunamadı."
            });
        }

        _context.Favorites.Remove(favorite);

        await _context.SaveChangesAsync();

        return Ok(new
        {
            message = "Ürün favorilerden çıkarıldı."
        });
    }

    // ============================================================
    // GET: api/favorites/user/{userId}/contains/{productId}
    // ============================================================

    [HttpGet("user/{userId:int}/contains/{productId:int}")]
    public async Task<IActionResult> IsFavorite(
        int userId,
        int productId)
    {
        var exists = await _context.Favorites
            .AnyAsync(favorite =>
                favorite.UserId == userId &&
                favorite.ProductId == productId);

        return Ok(new
        {
            isFavorite = exists
        });
    }
}

// ================================================================
// REQUEST MODEL
// ================================================================

public class FavoriteRequest
{
    public int UserId { get; set; }

    public int ProductId { get; set; }
}