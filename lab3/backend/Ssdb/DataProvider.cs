using System.Diagnostics;
using Ssdb.Controllers;
using System.Data.SqlClient;
using Ssdb.Dtos;
using Ssdb.Entities;

namespace Ssdb;

public class DataProvider
{
    private readonly string _connectionString;

    public DataProvider(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection");
    }

    #region Order

    public async Task<List<Order>> GetAllOrdersAsync()
    {
        var orders = new List<Order>();
        string query = @"SELECT * FROM orders";

        try
        {
            using var connection = new SqlConnection(_connectionString);
            using var command = new SqlCommand(query, connection);

            await connection.OpenAsync();
            using var reader = await command.ExecuteReaderAsync();

            while (await reader.ReadAsync())
            {
                var order = new Order
                {
                    Id = reader.GetInt32(0),
                    Status = Enum.Parse<OrderStatus>(reader.GetString(1), true),
                    Subtotal = reader.GetDecimal(2),
                    Description = reader.GetString(3),
                    PaymentMethod = Enum.Parse<PaymentMethod>(reader.GetString(4), true),
                    PaymentStatus = Enum.Parse<PaymentStatus>(reader.GetString(5), true),
                    DeliveryFee = reader.GetDecimal(6),
                    CollectedDate = reader.GetDateTime(7),
                    DeliveredDate = reader.GetDateTime(8),
                    UserId = reader.GetInt32(9),
                };
                orders.Add(order);
            }

            return orders;
        }
        catch (Exception e)
        {
            Debug.WriteLine($"Error: {e.Message}");
            return null;
        }
    }

    public async Task<Order> GetOrderByIdAsync(int id)
    {
        string query = @"SELECT * FROM orders WHERE order_id = @Id";

        try
        {
            using var connection = new SqlConnection(_connectionString);
            using var command = new SqlCommand(query, connection);
            command.Parameters.AddWithValue("@Id", id);

            await connection.OpenAsync();
            using var reader = await command.ExecuteReaderAsync();

            if (await reader.ReadAsync())
            {
                return new Order
                {
                    Id = reader.GetInt32(0),
                    Status = Enum.Parse<OrderStatus>(reader.GetString(1), true),
                    Subtotal = reader.GetDecimal(2),
                    Description = reader.GetString(3),
                    PaymentMethod = Enum.Parse<PaymentMethod>(reader.GetString(4), true),
                    PaymentStatus = Enum.Parse<PaymentStatus>(reader.GetString(5), true),
                    DeliveryFee = reader.GetDecimal(6),
                    CollectedDate = reader.GetDateTime(7),
                    DeliveredDate = reader.GetDateTime(8),
                    UserId = reader.GetInt32(9),
                };
            }
            else
            {
                return null;
            }
        }
        catch (Exception e)
        {
            Debug.WriteLine($"Error: {e.Message}");
            return null;
        }
    }

    public async Task<int> AddOrderAsync(Order order)
    {
        string query = @"INSERT INTO orders 
                (status, subtotal, description, 
                payment_method, payment_status, delivery_fee, 
                collected_date, delivered_date, user_id) 
            VALUES (@Status, @Subtotal, @Description, 
                @PaymentMethod, @PaymentStatus, @DeliveryFee, @CollectedDate,
                @DeliveredDate, @UserId);
            SELECT LAST_INSERT_ID();";

        try
        {
            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Status", order.Status.ToString());
                command.Parameters.AddWithValue("@Subtotal", order.Subtotal);
                command.Parameters.AddWithValue("@Description", order.Description);
                command.Parameters.AddWithValue("@PaymentMethod", order.PaymentMethod.ToString());
                command.Parameters.AddWithValue("@PaymentStatus", order.PaymentStatus.ToString());
                command.Parameters.AddWithValue("@DeliveryFee", order.DeliveryFee);
                command.Parameters.AddWithValue("@CollectedDate", order.CollectedDate);
                command.Parameters.AddWithValue("@DeliveredDate", order.DeliveredDate);
                command.Parameters.AddWithValue("@UserId", order.UserId);

                await connection.OpenAsync();
                var id = Convert.ToInt32(await command.ExecuteScalarAsync());

                return id;
            }
        }
        catch (Exception e)
        {
            Debug.WriteLine($"Error: {e.Message}");
            return -1;
        }
    }

    public async Task UpdateOrderAsync(Order order)
    {
        string query = @"UPDATE orders
            SET status = @Status, subtotal = @Subtotal, 
            description = @Description, payment_method = @PaymentMethod, 
            payment_status = @PaymentStatus, delivery_fee = @DeliveryFee, 
            collected_date = @CollectedDate, delivered_date = @DeliveredDate
            WHERE order_id = @Id";

        try
        {
            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Status", order.Status.ToString());
                command.Parameters.AddWithValue("@Subtotal", order.Subtotal);
                command.Parameters.AddWithValue("@Description", order.Description);
                command.Parameters.AddWithValue("@PaymentMethod", order.PaymentMethod.ToString());
                command.Parameters.AddWithValue("@PaymentStatus", order.PaymentStatus.ToString());
                command.Parameters.AddWithValue("@DeliveryFee", order.DeliveryFee);
                command.Parameters.AddWithValue("@CollectedDate", order.CollectedDate);
                command.Parameters.AddWithValue("@DeliveredDate", order.DeliveredDate);
                command.Parameters.AddWithValue("@Id", order.Id);

                await connection.OpenAsync();
                await command.ExecuteNonQueryAsync();
            }
        }
        catch (Exception e)
        {
            Debug.WriteLine($"Error: {e.Message}");
        }
    }

    public async Task DeleteOrderAsync(int id)
    {
        string query = "DELETE FROM orders WHERE order_id = @Id";

        try
        {
            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Id", id);

                await connection.OpenAsync();
                await command.ExecuteNonQueryAsync();
            }
        }
        catch (Exception e)
        {
            Debug.WriteLine($"Error: {e.Message}");
        }
    }

    #endregion

    #region OrderItem

    public async Task<List<OrderItem>> GetOrderItemsAsync(int orderId)
    {
        var orderItems = new List<OrderItem>();
        string query = @"SELECT * FROM order_item oi WHERE oi.order_id == @id";

        try
        {
            using var connection = new SqlConnection(_connectionString);
            using var command = new SqlCommand(query, connection);

            await connection.OpenAsync();
            using var reader = await command.ExecuteReaderAsync();

            while (await reader.ReadAsync())
            {
                var orderItem = new OrderItem
                {
                    Id = reader.GetInt32(0),
                    Quantity = reader.GetInt32(1),
                    OrderId = reader.GetInt32(4),
                };
                orderItems.Add(orderItem);
            }

            return orderItems;
        }
        catch (Exception e)
        {
            Debug.WriteLine($"Error: {e.Message}");
            return null;
        }
    }

    public async Task<OrderItem> GetOrderItemByIdAsync(int id)
    {
        string query = @"SELECT * FROM order_item WHERE order_item_id = @Id";

        try
        {
            using var connection = new SqlConnection(_connectionString);
            using var command = new SqlCommand(query, connection);
            command.Parameters.AddWithValue("@Id", id);

            await connection.OpenAsync();
            using var reader = await command.ExecuteReaderAsync();

            if (await reader.ReadAsync())
            {
                return new OrderItem
                {
                    Id = reader.GetInt32(0),
                    Quantity = reader.GetInt32(1),
                    OrderId = reader.GetInt32(4),
                };
            }
            else
            {
                return null;
            }
        }
        catch (Exception e)
        {
            Debug.WriteLine($"Error: {e.Message}");
            return null;
        }
    }

    public async Task<int> AddOrderItemAsync(OrderItem orderItem)
    {
        string query = @"INSERT INTO order_item 
                (quantity, price_per_unit, service_name, order_id) 
            VALUES (@Quantity, @PricePerUnit, @ServiceName, @OrderId);
            SELECT LAST_INSERT_ID();";

        try
        {
            using var connection = new SqlConnection(_connectionString);
            using var command = new SqlCommand(query, connection);

            command.Parameters.AddWithValue("@Quantity", orderItem.Quantity);
            command.Parameters.AddWithValue("@OrderId", orderItem.OrderId);

            await connection.OpenAsync();
            var id = Convert.ToInt32(await command.ExecuteScalarAsync());
            return id;
        }
        catch (Exception e)
        {
            Debug.WriteLine($"Error: {e.Message}");
            return -1;
        }
    }

    public async Task UpdateOrderItemAsync(OrderItem orderItem)
    {
        string query = @"UPDATE order_item
            SET quantity = @Quantity, price_per_unit = @PricePerUnit, 
            service_name = @ServiceName, order_id = @OrderId
            WHERE order_item_id = @Id";

        try
        {
            using var connection = new SqlConnection(_connectionString);
            using var command = new SqlCommand(query, connection);

            command.Parameters.AddWithValue("@Id", orderItem.Id);
            command.Parameters.AddWithValue("@Quantity", orderItem.Quantity);
            command.Parameters.AddWithValue("@OrderId", orderItem.OrderId);

            await connection.OpenAsync();
            await command.ExecuteNonQueryAsync();
        }
        catch (Exception e)
        {
            Debug.WriteLine($"Error: {e.Message}");
        }
    }

    public async Task DeleteOrderItemAsync(int id)
    {
        string query = "DELETE FROM order_item WHERE order_item_id = @Id";

        try
        {
            using var connection = new SqlConnection(_connectionString);
            using var command = new SqlCommand(query, connection);
            command.Parameters.AddWithValue("@Id", id);

            await connection.OpenAsync();
            await command.ExecuteNonQueryAsync();
        }
        catch (Exception e)
        {
            Debug.WriteLine($"Error: {e.Message}");
        }
    }

    #endregion

    #region User

    public async Task<List<User>> GetAllUsersAsync()
    {
        var users = new List<User>();
        string query = @"SELECT * FROM user";

        try
        {
            using var connection = new SqlConnection(_connectionString);
            using var command = new SqlCommand(query, connection);

            await connection.OpenAsync();
            using var reader = await command.ExecuteReaderAsync();

            while (await reader.ReadAsync())
            {
                var user = new User
                {
                    Id = reader.GetInt32(0),
                    FirstName = reader.GetString(1),
                    LastName = reader.GetString(2),
                    Email = reader.GetString(3),
                    PhoneNumber = reader.GetString(4),
                    Password = reader.GetString(5),
                    Role = Enum.Parse<Role>(reader.GetString(6), true),
                    Address = reader.GetString(7),
                };
                users.Add(user);
            }

            return users;
        }
        catch (Exception e)
        {
            Debug.WriteLine($"Error: {e.Message}");
            return null;
        }
    }

    public async Task<User> GetUserByIdAsync(int id)
    {
        string query = @"SELECT * FROM user WHERE user_id = @Id";

        try
        {
            using var connection = new SqlConnection(_connectionString);
            using var command = new SqlCommand(query, connection);
            command.Parameters.AddWithValue("@Id", id);

            await connection.OpenAsync();
            using var reader = await command.ExecuteReaderAsync();

            if (await reader.ReadAsync())
            {
                return new User
                {
                    Id = reader.GetInt32(0),
                    FirstName = reader.GetString(1),
                    LastName = reader.GetString(2),
                    Email = reader.GetString(3),
                    PhoneNumber = reader.GetString(4),
                    Password = reader.GetString(5),
                    Role = Enum.Parse<Role>(reader.GetString(6), true),
                    Address = reader.GetString(7),
                };
            }
            else
            {
                return null;
            }
        }
        catch (Exception e)
        {
            Debug.WriteLine($"Error: {e.Message}");
            return null;
        }
    }

    public async Task<int> AddUserAsync(User user)
    {
        string query = @"INSERT INTO user 
                (first_name, last_name, email, 
                phone_number, password, role, address) 
            VALUES (@FirstName, @LastName, @Email, 
                @PhoneNumber, @Password, @Role, @Address);
            SELECT LAST_INSERT_ID();";

        try
        {
            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@FirstName", user.FirstName);
                command.Parameters.AddWithValue("@LastName", user.LastName);
                command.Parameters.AddWithValue("@Email", user.Email);
                command.Parameters.AddWithValue("@PhoneNumber", user.PhoneNumber);
                command.Parameters.AddWithValue("@Password", user.Password);

                command.Parameters.AddWithValue("@Role", user.Role.ToString());
                command.Parameters.AddWithValue("@Address", user.Address);

                await connection.OpenAsync();
                var id = Convert.ToInt32(await command.ExecuteScalarAsync());
                return id;
            }
        }
        catch (Exception e)
        {
            Debug.WriteLine($"Error: {e.Message}");
            return -1;
        }
    }

    public async Task UpdateUserAsync(User user)
    {
        string query = @"UPDATE user 
            SET first_name = @FirstName, last_name = @LastName, 
            email = @Email, phone_number = @PhoneNumber, 
            password = @Password, role = @Role, address = @Address
            WHERE user_id = @Id";

        try
        {
            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Id", user.Id);
                command.Parameters.AddWithValue("@FirstName", user.FirstName);
                command.Parameters.AddWithValue("@LastName", user.LastName);
                command.Parameters.AddWithValue("@Email", user.Email);
                command.Parameters.AddWithValue("@PhoneNumber", user.PhoneNumber);
                command.Parameters.AddWithValue("@Password", user.Password);
                command.Parameters.AddWithValue("@Role", user.Role.ToString());
                command.Parameters.AddWithValue("@Address", user.Address);

                await connection.OpenAsync();
                await command.ExecuteNonQueryAsync();
            }
        }
        catch (Exception e)
        {
            Debug.WriteLine($"Error: {e.Message}");
        }
    }

    public async Task DeleteUserAsync(int id)
    {
        string query = "DELETE FROM user WHERE user_id = @Id";

        try
        {
            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Id", id);

                await connection.OpenAsync();
                await command.ExecuteNonQueryAsync();
            }
        }
        catch (Exception e)
        {
            Debug.WriteLine($"Error: {e.Message}");
        }
    }

    #endregion
}
