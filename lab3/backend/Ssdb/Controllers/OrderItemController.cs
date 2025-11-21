using Microsoft.AspNetCore.Mvc;
using Ssdb.Dtos;
using Ssdb.Entities;

namespace Ssdb.Controllers;

[ApiController]
[Route("api/[controller]")]
public class OrderItemController : ControllerBase
{
    private readonly DataProvider _dataProvider;

    public OrderItemController(DataProvider dataProvider) => _dataProvider = dataProvider;

    [HttpGet("order/{orderId:int}")]
    public async Task<ActionResult<List<OrderItem>>> GetOrderItems(int orderId)
    {
        var orderItems = await _dataProvider.GetOrderItemsAsync(orderId);
        if (orderItems == null || !orderItems.Any())
        {
            return NotFound($"No order items found for order ID {orderId}");
        }

        return Ok(orderItems);
    }

    [HttpGet("{id:int}")]
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
        var orderItem = new OrderItem
        {
            Quantity = orderItemDto.Quantity,
            ProductId = orderItemDto.ProductId,
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
        orderItem.ProductId = orderItemDto.ProductId;
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
}
