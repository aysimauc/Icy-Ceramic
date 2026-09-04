namespace ICYCeramic.Api.Models;

public class Category
{
    public int Id { get; set; }

    public string Name { get; set; } = string.Empty;

    public string? Image { get; set; }

    public ICollection<Product> Products { get; set; } = new List<Product>();
}