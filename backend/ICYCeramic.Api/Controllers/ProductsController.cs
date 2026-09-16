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

    [HttpPut("{id:int}")]
    public async Task<IActionResult> UpdateProduct(
        int id,
        [FromBody] UpdateProductRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.Name))
        {
            return BadRequest(new
            {
                message = "Ürün adı boş bırakılamaz."
            });
        }

        if (request.Price < 0)
        {
            return BadRequest(new
            {
                message = "Ürün fiyatı 0'dan küçük olamaz."
            });
        }

        if (string.IsNullOrWhiteSpace(request.Image))
        {
            return BadRequest(new
            {
                message = "Ürün görsel yolu boş bırakılamaz."
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

        product.Name = request.Name.Trim();
        product.Price = request.Price;
        product.Description =
            request.Description?.Trim() ?? string.Empty;
        product.Image = request.Image.Trim();

        await _context.SaveChangesAsync();

        return Ok(new
        {
            message = "Ürün bilgileri başarıyla güncellendi.",
            productId = product.Id,
            productName = product.Name,
            price = product.Price,
            description = product.Description,
            image = product.Image
        });
    }

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

        if (difference != 0)
        {
            var stockMovement = new StockMovement
            {
                ProductId = product.Id,
                Quantity = difference,
                MovementType = "ADJUSTMENT",
                ReferenceNumber =
                    $"STOCK-{product.Id}-{DateTime.UtcNow:yyyyMMddHHmmss}",
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
            oldStock,
            newStock,
            difference
        });
    }
}

public class UpdateProductRequest
{
    public string Name { get; set; } = string.Empty;
    public double Price { get; set; }
    public string Description { get; set; } = string.Empty;
    public string Image { get; set; } = string.Empty;
}

public class UpdateStockRequest
{
    public int Stock { get; set; }
}
