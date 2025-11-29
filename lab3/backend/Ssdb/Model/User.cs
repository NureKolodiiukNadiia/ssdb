using System.Data;
using System.Data.SqlClient;

namespace Ssdb.Model;

public class User
{
    public int Id { get; set; }
    public string FullName { get; set; } = "";
    public string? Email { get; set; }
    public string? Phone { get; set; }
    public DateTime CreatedAt { get; set; }

    public static User FromReader(IDataRecord r) =>
        new User
        {
            Id = (int)r["id"],
            FullName = (string)r["full_name"],
            Email = r["email"] as string,
            Phone = r["phone"] as string,
            CreatedAt = (DateTime)r["created_at"]
        };

    public SqlParameter[] ToInsertParameters() =>
        new[]
        {
            new SqlParameter("@full_name", FullName),
            new SqlParameter("@email", (object?)Email ?? DBNull.Value),
            new SqlParameter("@phone", (object?)Phone ?? DBNull.Value)
        };

    public SqlParameter[] ToUpdateParameters() =>
        new[]
        {
            new SqlParameter("@id", Id),
            new SqlParameter("@full_name", FullName),
            new SqlParameter("@email", (object?)Email ?? DBNull.Value),
            new SqlParameter("@phone", (object?)Phone ?? DBNull.Value)
        };
}
