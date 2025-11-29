using System.Data;
using System.Data.SqlClient;

namespace Ssdb.Model;

public class OrderItem
{
    public int Id { get; set; }
    public int OrderId { get; set; }
    public int ProductId { get; set; }
    public int Quantity { get; set; }
    public decimal Price { get; set; }

    public static OrderItem FromReader(IDataRecord r) =>
        new OrderItem
        {
            Id = (int)r["id"],
            OrderId = (int)r["order_id"],
            ProductId = (int)r["product_id"],
            Quantity = (int)r["quantity"],
            Price = (decimal)r["price"]
        };

    public SqlParameter[] ToInsertParameters() =>
        new[]
        {
            new SqlParameter("@order_id", OrderId),
            new SqlParameter("@product_id", ProductId),
            new SqlParameter("@quantity", Quantity),
            new SqlParameter("@price", Price)
        };

    public SqlParameter[] ToUpdateParameters() =>
        new[]
        {
            new SqlParameter("@id", Id),
            new SqlParameter("@order_id", OrderId),
            new SqlParameter("@product_id", ProductId),
            new SqlParameter("@quantity", Quantity),
            new SqlParameter("@price", Price)
        };
}
