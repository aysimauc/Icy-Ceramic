using ICYCeramic.Api.Data;
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
}