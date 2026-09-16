using ICYCeramic.Api.Data;
using ICYCeramic.Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ICYCeramic.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class OrdersController : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public OrdersController(ApplicationDbContext context)
    {
        _context = context;
    }

    // ============================================================
    // POST: api/orders
    // ============================================================

    [HttpPost]
    public async Task<IActionResult> CreateOrder(
        [FromBody] CreateOrderRequest request)
    {
        if (request.UserId <= 0)
        {
            return BadRequest(new
            {
                message = "Geçerli bir kullanıcı bulunamadı."
            });
        }

        if (string.IsNullOrWhiteSpace(request.Address))
        {
            return BadRequest(new
            {
                message = "Teslimat adresi zorunludur."
            });
        }

        if (request.Items == null ||
            request.Items.Count == 0)
        {
            return BadRequest(new
            {
                message = "Sipariş ürün içermelidir."
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

        await using var transaction =
            await _context.Database.BeginTransactionAsync();

        try
        {
            var productIds = request.Items
                .Select(item => item.ProductId)
                .Distinct()
                .ToList();

            var products = await _context.Products
                .Where(product =>
                    productIds.Contains(product.Id))
                .ToDictionaryAsync(
                    product => product.Id);

            if (products.Count != productIds.Count)
            {
                return BadRequest(new
                {
                    message = "Siparişte geçersiz ürün bulunmaktadır."
                });
            }

            double calculatedTotal = 0;

            foreach (var requestItem in request.Items)
            {
                if (requestItem.Quantity <= 0)
                {
                    return BadRequest(new
                    {
                        message = "Ürün miktarı geçersiz."
                    });
                }

                var product =
                    products[requestItem.ProductId];

                if (product.Stock < requestItem.Quantity)
                {
                    return BadRequest(new
                    {
                        message =
                            $"'{product.Name}' ürünü için yeterli stok bulunmuyor."
                    });
                }

                calculatedTotal +=
                    product.Price * requestItem.Quantity;
            }

            var orderNumber =
                $"ICY-{DateTime.UtcNow:yyyyMMddHHmmssfff}";

            var order = new Order
            {
                OrderNumber = orderNumber,
                UserId = request.UserId,
                Total = request.Total > 0
                    ? request.Total
                    : calculatedTotal,
                CreatedAt = DateTime.UtcNow,
                PaymentMethod =
                    string.IsNullOrWhiteSpace(
                        request.PaymentMethod)
                        ? "Kart"
                        : request.PaymentMethod.Trim(),
                Address = request.Address.Trim(),
                Status = "Hazırlanıyor"
            };

            _context.Orders.Add(order);

            foreach (var requestItem in request.Items)
            {
                var product =
                    products[requestItem.ProductId];

                var itemTotal =
                    product.Price *
                    requestItem.Quantity;

                var orderItem = new OrderItem
                {
                    Order = order,
                    ProductId = product.Id,
                    Quantity = requestItem.Quantity,
                    UnitPrice = product.Price,
                    TotalPrice = itemTotal
                };

                _context.OrderItems.Add(orderItem);

                // ====================================================
                // STOK DÜŞÜŞÜ
                // ====================================================

                product.Stock -= requestItem.Quantity;

                var stockMovement =
                    new StockMovement
                    {
                        ProductId = product.Id,
                        Quantity =
                            -requestItem.Quantity,
                        MovementType = "SALE",
                        ReferenceNumber =
                            orderNumber,
                        CreatedAt =
                            DateTime.UtcNow
                    };

                _context.StockMovements.Add(
                    stockMovement);
            }

            await _context.SaveChangesAsync();

            await transaction.CommitAsync();

            return Ok(new
            {
                message = "Sipariş başarıyla oluşturuldu.",
                orderId = order.Id,
                orderNumber = order.OrderNumber,
                total = order.Total,
                status = order.Status,
                createdAt = order.CreatedAt
            });
        }
        catch
        {
            await transaction.RollbackAsync();

            return StatusCode(500, new
            {
                message =
                    "Sipariş oluşturulurken bir hata oluştu."
            });
        }
    }

    // ============================================================
    // GET: api/orders/user/1
    // ============================================================

    [HttpGet("user/{userId:int}")]
    public async Task<IActionResult> GetUserOrders(
        int userId)
    {
        var orders = await _context.Orders
            .Where(order => order.UserId == userId)
            .Include(order => order.Items)
            .ThenInclude(item => item.Product)
            .OrderByDescending(order => order.CreatedAt)
            .Select(order => new
            {
                order.Id,
                order.OrderNumber,
                order.Total,
                order.CreatedAt,
                order.PaymentMethod,
                order.Address,
                order.Status,
                order.TrackingNumber,
                order.CargoCompany,

                items = order.Items.Select(item => new
                {
                    item.ProductId,
                    productName = item.Product.Name,
                    productImage = item.Product.Image,
                    item.Quantity,
                    item.UnitPrice,
                    item.TotalPrice
                })
            })
            .ToListAsync();

        return Ok(orders);
    }
}