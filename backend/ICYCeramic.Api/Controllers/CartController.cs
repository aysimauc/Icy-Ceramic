using ICYCeramic.Api.Data;
using ICYCeramic.Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ICYCeramic.Api.Controllers;

[ApiController]
[Route("api/cart")]
public class CartController : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public CartController(ApplicationDbContext context)
    {
        _context = context;
    }

    // ============================================================
    // GET: api/cart/user/{userId}
    // Kullanıcının sepetini getirir.
    // ============================================================

    [HttpGet("user/{userId}")]
    public async Task<IActionResult> GetCart(int userId)
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

        var cartItems = await _context.CartItems
            .Where(item => item.UserId == userId)
            .Select(item => new
            {
                productId = item.ProductId,
                quantity = item.Quantity
            })
            .ToListAsync();

        return Ok(cartItems);
    }

    // ============================================================
    // POST: api/cart
    // Sepete ürün ekler veya miktarını günceller.
    // ============================================================

    [HttpPost]
    public async Task<IActionResult> AddToCart(
        [FromBody] AddCartItemRequest request)
    {
        if (request.UserId <= 0)
        {
            return BadRequest(new
            {
                message = "Geçerli bir kullanıcı bulunamadı."
            });
        }

        if (request.ProductId <= 0)
        {
            return BadRequest(new
            {
                message = "Geçerli bir ürün bulunamadı."
            });
        }

        if (request.Quantity <= 0)
        {
            return BadRequest(new
            {
                message = "Ürün miktarı 0'dan büyük olmalıdır."
            });
        }

        var userExists = await _context.Users
            .AnyAsync(user => user.Id == request.UserId);

        if (!userExists)
        {
            return NotFound(new
            {
                message = "Kullanıcı bulunamadı."
            });
        }

        var product = await _context.Products
            .FirstOrDefaultAsync(
                product => product.Id == request.ProductId);

        if (product == null)
        {
            return NotFound(new
            {
                message = "Ürün bulunamadı."
            });
        }

        if (request.Quantity > product.Stock)
        {
            return BadRequest(new
            {
                message =
                    $"Sepetteki miktar stoktan fazla olamaz. Mevcut stok: {product.Stock}"
            });
        }

        var cartItem = await _context.CartItems
            .FirstOrDefaultAsync(item =>
                item.UserId == request.UserId &&
                item.ProductId == request.ProductId);

        if (cartItem == null)
        {
            cartItem = new CartItem
            {
                UserId = request.UserId,
                ProductId = request.ProductId,
                Quantity = request.Quantity,
                CreatedAt = DateTime.UtcNow
            };

            _context.CartItems.Add(cartItem);
        }
        else
        {
            cartItem.Quantity = request.Quantity;
        }

        await _context.SaveChangesAsync();

        return Ok(new
        {
            message = "Sepet güncellendi.",
            productId = cartItem.ProductId,
            quantity = cartItem.Quantity
        });
    }

    // ============================================================
    // DELETE: api/cart/{userId}/{productId}
    // Sepetten tek ürün siler.
    // ============================================================

    [HttpDelete("{userId}/{productId}")]
    public async Task<IActionResult> RemoveFromCart(
        int userId,
        int productId)
    {
        var cartItem = await _context.CartItems
            .FirstOrDefaultAsync(item =>
                item.UserId == userId &&
                item.ProductId == productId);

        if (cartItem == null)
        {
            return NotFound(new
            {
                message = "Ürün sepette bulunamadı."
            });
        }

        _context.CartItems.Remove(cartItem);

        await _context.SaveChangesAsync();

        return Ok(new
        {
            message = "Ürün sepetten çıkarıldı."
        });
    }

    // ============================================================
    // DELETE: api/cart/user/{userId}
    // Kullanıcının tüm sepetini temizler.
    // ============================================================

    [HttpDelete("user/{userId}")]
    public async Task<IActionResult> ClearCart(int userId)
    {
        var cartItems = await _context.CartItems
            .Where(item => item.UserId == userId)
            .ToListAsync();

        if (cartItems.Any())
        {
            _context.CartItems.RemoveRange(cartItems);

            await _context.SaveChangesAsync();
        }

        return Ok(new
        {
            message = "Sepet temizlendi."
        });
    }
}

// ============================================================
// REQUEST MODEL
// ============================================================

public class AddCartItemRequest
{
    public int UserId { get; set; }

    public int ProductId { get; set; }

    public int Quantity { get; set; }
}