using System.Data;
using System.Data.SqlClient;

namespace Ssdb.Model;

public class Product
{
    public int Id { get; set; }
    public string ProductName { get; set; } = "";
    public string Department { get; set; } = "";
    public int Quantity { get; set; }
    public decimal Price { get; set; }
    public string? Description { get; set; }

    public static Product FromReader(IDataRecord r) =>
        new Product
        {
            Id = (int)r["id"],
            ProductName = (string)r["product_name"],
            Department = (string)r["department"],
            Quantity = (int)r["quantity"],
            Price = (decimal)r["price"],
            Description = r["description"] as string
        };

    public SqlParameter[] ToInsertParameters() =>
        new[]
        {
            new SqlParameter("@product_name", ProductName),
            new SqlParameter("@department", Department),
            new SqlParameter("@quantity", Quantity),
            new SqlParameter("@price", Price),
            new SqlParameter("@description", (object?)Description ?? DBNull.Value)
        };

    public SqlParameter[] ToUpdateParameters() =>
        new[]
        {
            new SqlParameter("@id", Id),
            new SqlParameter("@product_name", ProductName),
            new SqlParameter("@department", Department),
            new SqlParameter("@quantity", Quantity),
            new SqlParameter("@price", Price),
            new SqlParameter("@description", (object?)Description ?? DBNull.Value)
        };
}
