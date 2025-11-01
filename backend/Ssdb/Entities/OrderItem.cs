namespace Ssdb;

public record OrderItem
{
    public int Id { get; set; }
    public int Quantity { get; set; }
    public decimal PricePerUnit { get; set; }
    public string ServiceName { get; set; }
    public int OrderId { get; set; }
}
