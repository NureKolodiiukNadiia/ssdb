namespace Ssdb.Controllers;

public class CreateOrderItemDto
{
    public int Quantity { get; set; }
    public decimal PricePerUnit { get; set; }
    public string ServiceName { get; set; }
    public int OrderId { get; set; }
}