namespace ICYCeramic.Api.Models;

public class Order
{
    public int Id { get; set; }

    public string OrderNumber { get; set; } = string.Empty;

    public int UserId { get; set; }

    public double Total { get; set; }

    public DateTime CreatedAt { get; set; }

    public string PaymentMethod { get; set; } = string.Empty;

    public string Address { get; set; } = string.Empty;

    public string Status { get; set; } = "Hazırlanıyor";

    public string? TrackingNumber { get; set; }

    public string? CargoCompany { get; set; }

    public User User { get; set; } = null!;

    public ICollection<OrderItem> Items { get; set; } =
        new List<OrderItem>();
}