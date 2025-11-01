using Microsoft.AspNetCore.Mvc;

namespace Ssdb.Controllers;

[ApiController]
[Route("api/[controller]")]
public class OrderItemController : ControllerBase
{
    private DataProvider _dataProvider;

    public OrderItemController(DataProvider dataProvider) => _dataProvider = dataProvider;

    [HttpGet]
    public async Task<ActionResult<List<OrderItem>>> GetOrderItems()
    {
        var orderItems = await _dataProvider.GetAllOrderItemsAsync();
        return Ok(orderItems.ToArray());
        // return Ok(new OrderItem[1]
        //     { new OrderItem() { Id = 1, OrderId = 2, ServiceName = "fewuhi", PricePerUnit = 34, Quantity = 2 } });
    }

    [HttpGet("{id}", Name = "GetOrderItem")]
    public async Task<ActionResult<OrderItem>> GetOrderItem(int id)
    {
        var orderItem = await _dataProvider.GetOrderItemByIdAsync(id);
        
        if (orderItem == null)
        {
            return NotFound();
        }

        return Ok(orderItem);
    }

    [HttpPost]
    public async Task<ActionResult<OrderItem>> CreateOrderItem([FromForm] CreateOrderItemDto orderItemDto)
    {
        if (orderItemDto == null)
        {
            return BadRequest(new ProblemDetails { Title = "Invalid order item data" });
        }
        var orderItem = new OrderItem()
        {
            Quantity = orderItemDto.Quantity,
            PricePerUnit = orderItemDto.PricePerUnit,
            ServiceName = orderItemDto.ServiceName,
            OrderId = orderItemDto.OrderId,
        };

        try
        {
            int id = await _dataProvider.AddOrderItemAsync(orderItem);
            orderItem.Id = id;
            
            return CreatedAtRoute("GetOrderItem", new { Id = orderItem.Id }, orderItem);
        }
        catch (Exception e)
        {
            return BadRequest(new ProblemDetails { Title = "Problem creating new order item" });
        }
    }

    [HttpPut]
    public async Task<ActionResult<OrderItem>> UpdateOrderItem([FromForm] OrderItem orderItemDto)
    {
        if (orderItemDto == null)
        {
            return BadRequest(new ProblemDetails { Title = "Invalid order item data" });
        }
        var orderItem = await _dataProvider.GetOrderItemByIdAsync(orderItemDto.Id);

        if (orderItem == null)
        {
            return NotFound();
        }

        orderItem.Quantity = orderItemDto.Quantity;
        orderItem.PricePerUnit = orderItemDto.PricePerUnit;
        orderItem.ServiceName = orderItemDto.ServiceName;
        orderItem.OrderId = orderItemDto.OrderId;

        try
        {
            await _dataProvider.UpdateOrderItemAsync(orderItem);
        }
        catch (Exception e)
        {
            return BadRequest(new ProblemDetails { Title = "Problem updating order item" });
        }

        return Ok(orderItem);
    }

    [HttpDelete("{id}")]
    public async Task<ActionResult> DeleteOrderItem(int id)
    {
        await _dataProvider.DeleteOrderItemAsync(id);
        
        return Ok();
    }
    
    [HttpGet("order-items/{orderId}")]
    public async Task<IActionResult> GetOrderItemsByOrderId(int orderId)
    {
        var orderItems = await _dataProvider.GetOrderItemsByOrderIdAsync(orderId);
        if (orderItems == null || !orderItems.Any())
        {
            return NotFound($"No order items found for order ID {orderId}");
        }

        return Ok(orderItems);
    }
 
}
