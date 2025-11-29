using Microsoft.AspNetCore.Mvc;
using Ssdb.Model;

namespace Ssdb.Controllers;

[ApiController]
[Route("api/[controller]")]
public class OrderController : ControllerBase
{
    private readonly DataProvider _dataProvider;

    public OrderController(DataProvider dataProvider) => _dataProvider = dataProvider;

    [HttpGet]
    public async Task<ActionResult<List<Order>>> GetOrders([FromQuery] bool includeItems = false)
        => Ok(await _dataProvider.GetAllOrdersAsync(includeItems));

    [HttpGet("{id:int}", Name = nameof(GetOrder))]
    public async Task<ActionResult<Order>> GetOrder(int id)
    {
        var order = await _dataProvider.GetOrderAsync(id);

        return order == null ? NotFound() : Ok(order);
    }

    [HttpGet("{id:int}/with-items")]
    public async Task<ActionResult<Order>> GetOrderWithItems(int id)
    {
        var order = await _dataProvider.GetOrderWithItemsAsync(id);

        return order == null ? NotFound() : Ok(order);
    }

    [HttpPost]
    public async Task<ActionResult<Order>> CreateOrder([FromBody] Order order)
    {
        if (order == null)
        {
            return BadRequest();
        }

        var id = await _dataProvider.AddOrderAsync(order);
        order.Id = id;

        return CreatedAtRoute(nameof(GetOrder), new { id }, order);
    }

    [HttpPut("{id:int}")]
    public async Task<ActionResult<Order>> UpdateOrder(int id, [FromBody] Order order)
    {
        if (order == null || id != order.Id)
        {
            return BadRequest();
        }

        var existing = await _dataProvider.GetOrderAsync(id);
        if (existing == null)
        {
            return NotFound();
        }

        existing.UserId = order.UserId;
        existing.PlacedAt = order.PlacedAt;
        existing.Total = order.Total;

        await _dataProvider.UpdateOrderAsync(existing);

        return Ok(existing);
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> DeleteOrder(int id)
    {
        var existing = await _dataProvider.GetOrderAsync(id);
        if (existing == null)
        {
            return NotFound();
        }

        await _dataProvider.DeleteOrderAsync(id);

        return NoContent();
    }
}
