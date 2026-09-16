using ICYCeramic.Api.Data;
using ICYCeramic.Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ICYCeramic.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public ProductsController(ApplicationDbContext context)
    {
        _context = context;
    }

    // ============================================================
    // TÜM ÜRÜNLERİ GETİR
    // ============================================================

    [HttpGet]
    public async Task<IActionResult> GetProducts()
    {
        var products = await _context.Products
            .AsNoTracking()
            .Include(product => product.Category)
            .Select(product => new
            {
                id = product.Id,
                name = product.Name,
                categoryId = product.CategoryId,
                category = product.Category.Name,
                price = product.Price,
                image = product.Image,
                description = product.Description,
                stock = product.Stock
            })
            .ToListAsync();

        return Ok(products);
    }

    // ============================================================
    // TEK ÜRÜNÜ GETİR
    // ============================================================

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetProduct(int id)
    {
        var product = await _context.Products
            .AsNoTracking()
            .Include(product => product.Category)
            .Where(product => product.Id == id)
            .Select(product => new
            {
                id = product.Id,
                name = product.Name,
                categoryId = product.CategoryId,
                category = product.Category.Name,
                price = product.Price,
                image = product.Image,
                description = product.Description,
                stock = product.Stock
            })
            .FirstOrDefaultAsync();

        if (product == null)
        {
            return NotFound(new
            {
                message = "Ürün bulunamadı."
            });
        }

        return Ok(product);
    }

    // ============================================================
    // STOK GÜNCELLE
    // ============================================================

    [HttpPut("{id:int}/stock")]
    public async Task<IActionResult> UpdateStock(
        int id,
        [FromBody] UpdateStockRequest request)
    {
        if (request.Stock < 0)
        {
            return BadRequest(new
            {
                message = "Stok miktarı 0'dan küçük olamaz."
            });
        }

        var product = await _context.Products
            .FirstOrDefaultAsync(product => product.Id == id);

        if (product == null)
        {
            return NotFound(new
            {
                message = "Ürün bulunamadı."
            });
        }

        int oldStock = product.Stock;
        int newStock = request.Stock;
        int difference = newStock - oldStock;

        product.Stock = newStock;

        // Stok değişikliğini hareket tablosuna kaydet.
        if (difference != 0)
        {
            var stockMovement = new StockMovement
            {
                ProductId = product.Id,
                Quantity = difference,
                MovementType = "ADJUSTMENT",
                ReferenceNumber = $"STOCK-{product.Id}-{DateTime.UtcNow:yyyyMMddHHmmss}",
                CreatedAt = DateTime.UtcNow
            };

            _context.StockMovements.Add(stockMovement);
        }

        await _context.SaveChangesAsync();

        return Ok(new
        {
            message = "Stok başarıyla güncellendi.",
            productId = product.Id,
            productName = product.Name,
            oldStock = oldStock,
            newStock = newStock,
            difference = difference
        });
    }
}

// ============================================================
// STOK GÜNCELLEME İSTEĞİ
// ============================================================

public class UpdateStockRequest
{
    public int Stock { get; set; }
}