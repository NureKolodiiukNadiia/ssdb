using System.Data;
using System.Data.SqlClient;
using Ssdb.Model;

namespace Ssdb;

public class DataProvider
{
    private readonly string _connectionString;

    public DataProvider(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection")
                            ?? throw new InvalidOperationException("Missing connection string 'DefaultConnection'.");
    }

    #region Users

    public async Task<List<User>> GetAllUsersAsync()
    {
        const string sql = @"SELECT id, full_name, email, phone, created_at FROM lab.users ORDER BY id";
        var result = new List<User>();

        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand(sql, connection);
        await connection.OpenAsync();
        await using var reader = await command.ExecuteReaderAsync();

        while (await reader.ReadAsync())
        {
            result.Add(User.FromReader(reader));
        }

        return result;
    }

    public async Task<User?> GetUserAsync(int id)
    {
        const string sql = @"SELECT id, full_name, email, phone, created_at FROM lab.users WHERE id = @id";
        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@id", id);

        await connection.OpenAsync();
        await using var reader = await command.ExecuteReaderAsync();
        return await reader.ReadAsync() ? User.FromReader(reader) : null;
    }

    public async Task<int> AddUserAsync(User user)
    {
        const string sql = @"INSERT INTO lab.users (full_name, email, phone)
                                         VALUES (@full_name, @email, @phone);
                                         SELECT CAST(SCOPE_IDENTITY() AS INT);";
        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand(sql, connection);
        command.Parameters.AddRange(user.ToInsertParameters());

        await connection.OpenAsync();
        return Convert.ToInt32(await command.ExecuteScalarAsync());
    }

    public async Task UpdateUserAsync(User user)
    {
        const string sql = @"UPDATE lab.users
                                         SET full_name = @full_name, email = @email, phone = @phone
                                         WHERE id = @id";
        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand(sql, connection);
        command.Parameters.AddRange(user.ToUpdateParameters());

        await connection.OpenAsync();
        await command.ExecuteNonQueryAsync();
    }

    public async Task DeleteUserAsync(int id)
    {
        const string sql = @"DELETE FROM lab.users WHERE id = @id";
        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@id", id);

        await connection.OpenAsync();
        await command.ExecuteNonQueryAsync();
    }

    #endregion

    #region Products

    public async Task<List<Product>> GetAllProductsAsync()
    {
        const string sql = @"SELECT id, product_name, department, quantity, price, description
                                         FROM lab.product ORDER BY id";
        var result = new List<Product>();

        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand(sql, connection);
        await connection.OpenAsync();
        await using var reader = await command.ExecuteReaderAsync();

        while (await reader.ReadAsync())
        {
            result.Add(Product.FromReader(reader));
        }

        return result;
    }

    public async Task<Product?> GetProductAsync(int id)
    {
        const string sql = @"SELECT id, product_name, department, quantity, price, description
                                         FROM lab.product WHERE id = @id";
        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@id", id);

        await connection.OpenAsync();
        await using var reader = await command.ExecuteReaderAsync();
        return await reader.ReadAsync() ? Product.FromReader(reader) : null;
    }

    public async Task<int> AddProductAsync(Product product)
    {
        const string sql = @"INSERT INTO lab.product (product_name, department, quantity, price, description)
                                         VALUES (@product_name, @department, @quantity, @price, @description);
                                         SELECT CAST(SCOPE_IDENTITY() AS INT);";
        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand(sql, connection);
        command.Parameters.AddRange(product.ToInsertParameters());

        await connection.OpenAsync();
        return Convert.ToInt32(await command.ExecuteScalarAsync());
    }

    public async Task UpdateProductAsync(Product product)
    {
        const string sql = @"UPDATE lab.product
                                         SET product_name = @product_name,
                                             department = @department,
                                             quantity = @quantity,
                                             price = @price,
                                             description = @description
                                         WHERE id = @id";
        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand(sql, connection);
        command.Parameters.AddRange(product.ToUpdateParameters());

        await connection.OpenAsync();
        await command.ExecuteNonQueryAsync();
    }

    public async Task DeleteProductAsync(int id)
    {
        const string sql = @"DELETE FROM lab.product WHERE id = @id";
        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@id", id);

        await connection.OpenAsync();
        await command.ExecuteNonQueryAsync();
    }

    #endregion

    #region Orders

    public async Task<List<Order>> GetAllOrdersAsync(bool includeItems = false)
    {
        const string sql = @"SELECT id, user_id, placed_at, total FROM lab.orders ORDER BY placed_at DESC";
        var orders = new List<Order>();

        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand(sql, connection);
        await connection.OpenAsync();
        await using var reader = await command.ExecuteReaderAsync();

        while (await reader.ReadAsync())
        {
            orders.Add(Order.FromReader(reader));
        }

        if (includeItems)
        {
            foreach (var order in orders)
            {
                order.Items = await GetOrderItemsAsync(order.Id);
            }
        }

        return orders;
    }

    public async Task<Order?> GetOrderAsync(int id)
    {
        const string sql = @"SELECT id, user_id, placed_at, total FROM lab.orders WHERE id = @id";
        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@id", id);

        await connection.OpenAsync();
        await using var reader = await command.ExecuteReaderAsync();
        return await reader.ReadAsync() ? Order.FromReader(reader) : null;
    }

    public async Task<Order?> GetOrderWithItemsAsync(int id)
    {
        const string sql = @"
                        SELECT id, user_id, placed_at, total FROM lab.orders WHERE id = @id;
                        SELECT id, order_id, product_id, quantity, price
                        FROM lab.order_items WHERE order_id = @id ORDER BY id;";
        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@id", id);

        await connection.OpenAsync();
        await using var reader = await command.ExecuteReaderAsync();

        if (!await reader.ReadAsync())
        {
            return null;
        }

        var order = Order.FromReader(reader);

        if (await reader.NextResultAsync())
        {
            var items = new List<OrderItem>();
            while (await reader.ReadAsync())
            {
                items.Add(OrderItem.FromReader(reader));
            }

            order.Items = items;
        }

        return order;
    }

    public async Task<int> AddOrderAsync(Order order)
    {
        if (order.PlacedAt == default)
        {
            order.PlacedAt = DateTime.UtcNow;
        }

        const string sql = @"INSERT INTO lab.orders (user_id, placed_at, total)
                                         VALUES (@user_id, @placed_at, @total);
                                         SELECT CAST(SCOPE_IDENTITY() AS INT);";
        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand(sql, connection);
        command.Parameters.AddRange(order.ToInsertParameters());

        await connection.OpenAsync();
        return Convert.ToInt32(await command.ExecuteScalarAsync());
    }

    public async Task UpdateOrderAsync(Order order)
    {
        const string sql = @"UPDATE lab.orders
                                         SET user_id = @user_id, placed_at = @placed_at, total = @total
                                         WHERE id = @id";
        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand(sql, connection);
        command.Parameters.AddRange(order.ToUpdateParameters());

        await connection.OpenAsync();
        await command.ExecuteNonQueryAsync();
    }

    public async Task DeleteOrderAsync(int id)
    {
        const string sql = @"DELETE FROM lab.orders WHERE id = @id";
        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@id", id);

        await connection.OpenAsync();
        await command.ExecuteNonQueryAsync();
    }

    #endregion

    #region OrderItems

    public async Task<List<OrderItem>> GetOrderItemsAsync(int orderId)
    {
        const string sql = @"SELECT id, order_id, product_id, quantity, price
                                         FROM lab.order_items WHERE order_id = @order_id ORDER BY id";
        var items = new List<OrderItem>();

        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@order_id", orderId);

        await connection.OpenAsync();
        await using var reader = await command.ExecuteReaderAsync();

        while (await reader.ReadAsync())
        {
            items.Add(OrderItem.FromReader(reader));
        }

        return items;
    }

    public async Task<OrderItem?> GetOrderItemAsync(int id)
    {
        const string sql = @"SELECT id, order_id, product_id, quantity, price
                                         FROM lab.order_items WHERE id = @id";
        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@id", id);

        await connection.OpenAsync();
        await using var reader = await command.ExecuteReaderAsync();
        return await reader.ReadAsync() ? OrderItem.FromReader(reader) : null;
    }

    public async Task<int> AddOrderItemAsync(OrderItem orderItem)
    {
        const string sql = @"INSERT INTO lab.order_items (order_id, product_id, quantity, price)
                                         VALUES (@order_id, @product_id, @quantity, @price);
                                         SELECT CAST(SCOPE_IDENTITY() AS INT);";
        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand(sql, connection);
        command.Parameters.AddRange(orderItem.ToInsertParameters());

        await connection.OpenAsync();
        return Convert.ToInt32(await command.ExecuteScalarAsync());
    }

    public async Task UpdateOrderItemAsync(OrderItem orderItem)
    {
        const string sql = @"UPDATE lab.order_items
                                         SET order_id = @order_id,
                                             product_id = @product_id,
                                             quantity = @quantity,
                                             price = @price
                                         WHERE id = @id";
        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand(sql, connection);
        command.Parameters.AddRange(orderItem.ToUpdateParameters());

        await connection.OpenAsync();
        await command.ExecuteNonQueryAsync();
    }

    public async Task DeleteOrderItemAsync(int id)
    {
        const string sql = @"DELETE FROM lab.order_items WHERE id = @id";
        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@id", id);

        await connection.OpenAsync();
        await command.ExecuteNonQueryAsync();
    }

    #endregion

    #region Routines & Functions

    public async Task MarkProductsByPriceGroupAsync(string department)
    {
        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand("lab.MarkProductsByPriceGroup", connection)
        {
            CommandType = CommandType.StoredProcedure
        };
        command.Parameters.AddWithValue("@department", department);

        await connection.OpenAsync();
        try
        {
            await command.ExecuteNonQueryAsync();
        }
        catch (SqlException ex) when (ex.Number == 50000)
        {
            throw new InvalidOperationException($"Server rejected the request: {ex.Message}", ex);
        }
    }

    public async Task<int> CountProductsByDepartmentAsync(string? deptPattern = null)
    {
        const string sql = @"SELECT lab.fn_CountProductsByDepartment(@pattern)";
        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@pattern", (object?)deptPattern ?? DBNull.Value);

        await connection.OpenAsync();
        var result = await command.ExecuteScalarAsync();
        return result is DBNull ? 0 : Convert.ToInt32(result);
    }

    public async Task<List<Product>> GetLowStockProductsAsync(int maxQuantity)
    {
        const string sql = @"SELECT id, product_name, department, quantity, price, description
                                         FROM lab.fn_LowStockProducts(@maxQuantity)
                                         ORDER BY quantity, id";
        var products = new List<Product>();

        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@maxQuantity", maxQuantity);

        await connection.OpenAsync();
        await using var reader = await command.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            products.Add(Product.FromReader(reader));
        }

        return products;
    }

    #endregion
}
