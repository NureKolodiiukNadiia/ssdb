using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Mvc;
using Ssdb.Model;

namespace Ssdb.Controllers;

[ApiController]
[Route("api/[controller]")]
public class RoutinesController : ControllerBase
{
    private readonly DataProvider _dataProvider;

    public RoutinesController(DataProvider dataProvider) => _dataProvider = dataProvider;

    [HttpPost("mark-products")]
    public async Task<IActionResult> MarkProducts([FromBody] MarkProductsRequest request)
    {
        if (request == null || string.IsNullOrWhiteSpace(request.Department))
        {
            return BadRequest();
        }

        try
        {
            await _dataProvider.MarkProductsByPriceGroupAsync(request.Department.Trim());
            
            return NoContent();
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpGet("count-products")]
    public async Task<ActionResult<int>> CountProducts([FromQuery] string? departmentPattern = null)
        => Ok(await _dataProvider.CountProductsByDepartmentAsync(departmentPattern));

    [HttpGet("low-stock")]
    public async Task<ActionResult<List<Product>>> GetLowStock([FromQuery] int maxQuantity = 5)
        => Ok(await _dataProvider.GetLowStockProductsAsync(maxQuantity));
}

public record MarkProductsRequest
{
    [Required] public string Department { get; init; } = string.Empty;
}
