using Ssdb.Entities;

namespace Ssdb.Dtos;

public class CreateOrderDto
{
    public OrderStatus Status { get; set; }
    public decimal Subtotal { get; set; }
    public string Description { get; set; }
    public PaymentMethod PaymentMethod { get; set; }
    public PaymentStatus PaymentStatus { get; set; }
    public decimal DeliveryFee { get; set; }
    public DateTime CollectedDate { get; set; }
    public DateTime DeliveredDate { get; set; }
    public int UserId { get; set; }
}