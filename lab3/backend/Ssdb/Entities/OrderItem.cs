namespace Ssdb.Entities;

public record OrderItem
{
    public int Id { get; set; }

    public int Quantity { get; set; }


    public int ProductId { get; set; }

    public int OrderId { get; set; }
}

public class Product
{
    public int Id { get; set; }

    public string ProductName { get; set; }

    public int QuantityInStock { get; set; }

    public decimal Price { get; set; }

    public int UserId { get; set; }
}
