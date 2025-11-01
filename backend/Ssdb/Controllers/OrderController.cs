using Microsoft.AspNetCore.Mvc;

namespace Ssdb.Controllers;

[ApiController]
[Route("api/[controller]")]
public class OrderController : ControllerBase
{
    private DataProvider _dataProvider;

    public OrderController(DataProvider dataProvider) => _dataProvider = dataProvider;

    [HttpGet]
    public async Task<ActionResult<List<Order>>> GetOrders()
    {
        var orders = await _dataProvider.GetAllOrdersAsync();

        return Ok(orders.ToArray());
    }

    [HttpGet("{id}", Name = "GetOrder")]
    public async Task<ActionResult<Order>> GetOrder(int id)
    {
        var order = await _dataProvider.GetOrderByIdAsync(id);

        if (order == null)
        {
            return NotFound();
        }

        return Ok(order);
    }

    [HttpPost]
    public async Task<ActionResult<Order>> CreateOrder([FromForm] CreateOrderDto orderDto)
    {
        if (orderDto == null)
        {
            return BadRequest(new ProblemDetails { Title = "Invalid order data" });
        }

        var order = new Order
        {
            Status = orderDto.Status,
            Subtotal = orderDto.Subtotal,
            Description = orderDto.Description,
            PaymentMethod = orderDto.PaymentMethod,
            PaymentStatus = orderDto.PaymentStatus,
            DeliveryFee = orderDto.DeliveryFee,
            CollectedDate = orderDto.CollectedDate,
            DeliveredDate = orderDto.DeliveredDate,
            UserId = orderDto.UserId,
        };

        try
        {
            int id = await _dataProvider.AddOrderAsync(order);
            order.Id = id;

            return CreatedAtRoute("GetOrder", new { Id = order.Id }, order);
        }
        catch (Exception e)
        {
            return BadRequest(new ProblemDetails { Title = "Problem creating new order" });
        }
    }

    [HttpPut]
    public async Task<ActionResult<Order>> UpdateOrder([FromForm] Order orderDto)
    {
        if (orderDto == null)
        {
            return BadRequest(new ProblemDetails { Title = "Invalid order data" });
        }

        var order = await _dataProvider.GetOrderByIdAsync(orderDto.Id);

        if (order == null)
        {
            return NotFound();
        }

        order.Status = orderDto.Status;
        order.Subtotal = orderDto.Subtotal;
        order.Description = orderDto.Description;
        order.PaymentMethod = orderDto.PaymentMethod;
        order.PaymentStatus = orderDto.PaymentStatus;
        order.DeliveryFee = orderDto.DeliveryFee;
        order.CollectedDate = orderDto.CollectedDate;
        order.DeliveredDate = orderDto.DeliveredDate;
        order.UserId = orderDto.UserId;

        try
        {
            await _dataProvider.UpdateOrderAsync(order);
        }
        catch (Exception e)
        {
            return BadRequest(new ProblemDetails { Title = "Problem updating order" });
        }

        return Ok(order);
    }

    [HttpDelete("{id}")]
    public async Task<ActionResult> DeleteOrder(int id)
    {
        await _dataProvider.DeleteOrderAsync(id);

        return Ok();
    }
}