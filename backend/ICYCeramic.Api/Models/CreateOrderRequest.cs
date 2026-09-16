namespace ICYCeramic.Api.Models;

public class CreateOrderRequest
{
    public int UserId { get; set; }

    public string PaymentMethod { get; set; } = string.Empty;

    public string Address { get; set; } = string.Empty;

    public double Total { get; set; }

    public List<CreateOrderItemRequest> Items { get; set; } =
        new();
}

public class CreateOrderItemRequest
{
    public int ProductId { get; set; }

    public int Quantity { get; set; }
}