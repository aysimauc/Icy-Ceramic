namespace ICYCeramic.Api.Models;

public class StockMovement
{
    public int Id { get; set; }

    public int ProductId { get; set; }

    public int Quantity { get; set; }

    public string MovementType { get; set; } = string.Empty;

    public string? ReferenceNumber { get; set; }

    public DateTime CreatedAt { get; set; }

    public Product Product { get; set; } = null!;
}