namespace Ssdb.Dtos;

public class UserWithMultipleOrders
{
    public int UserId { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public int OrderCount { get; set; }
}
