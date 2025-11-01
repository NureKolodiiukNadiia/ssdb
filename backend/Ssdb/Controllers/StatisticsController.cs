using Microsoft.AspNetCore.Mvc;

namespace Ssdb.Controllers;

[ApiController]
[Route("api/[controller]")]
public class StatisticsController : ControllerBase
{
    private DataProvider _dataProvider;

    public StatisticsController(DataProvider dataProvider) => _dataProvider = dataProvider;
    
    [HttpGet("customers-highest-order")]
    public async Task<IActionResult> GetCustomersWithHighestOrder()
    {
        var customers = await _dataProvider.GetCustomersWithHighestOrderAsync();
        
        return Ok(customers);
    }

    [HttpGet("users-multiple-orders")]
    public async Task<IActionResult> GetUsersWithMultipleOrders()
    {
        var users = await _dataProvider.GetUsersWithMultipleOrdersAsync();
        
        return Ok(users);
    }
    
    [HttpGet("washing-users")]
    public async Task<IActionResult> GetUsersWhoOrderedWashing()
    {
        var users = await _dataProvider.GetUsersWhoOrderedWashingAsync();
        if (users == null || users.Count == 0)
        {
            return NotFound("No users found who ordered 'Прання'.");
        }

        return Ok(users);
    }
}