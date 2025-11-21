namespace Ssdb.Entities;

public record Order
{
    public int Id { get; set; }
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

public enum PaymentStatus
{
    Unpaid,
    Paid,
}

public enum PaymentMethod
{
    Cash,
    CreditCard,
}

public enum OrderStatus
{
    Created,
    Accepted,
    Collected,
    InProgress,
    Delivered,
}