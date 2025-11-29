using System.Data;
using System.Data.SqlClient;

namespace Ssdb.Model;

public class Order
{
    public int Id { get; set; }

    public int UserId { get; set; }

    public DateTime PlacedAt { get; set; }

    public decimal Total { get; set; }

    public List<OrderItem>? Items { get; set; }

    public static Order FromReader(IDataRecord r) =>
        new Order
        {
            Id = (int)r["id"],
            UserId = (int)r["user_id"],
            PlacedAt = (DateTime)r["placed_at"],
            Total = (decimal)r["total"]
        };

    public SqlParameter[] ToInsertParameters() =>
        new[]
        {
            new SqlParameter("@user_id", UserId),
            new SqlParameter("@placed_at", PlacedAt),
            new SqlParameter("@total", Total)
        };

    public SqlParameter[] ToUpdateParameters() =>
        new[]
        {
            new SqlParameter("@id", Id),
            new SqlParameter("@user_id", UserId),
            new SqlParameter("@placed_at", PlacedAt),
            new SqlParameter("@total", Total)
        };
}
