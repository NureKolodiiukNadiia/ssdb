namespace Ssdb.Dtos;

public class CreateOrderItemDto
{
    public int Quantity { get; set; }

    public int ProductId { get; set; }

    public int OrderId { get; set; }
}
