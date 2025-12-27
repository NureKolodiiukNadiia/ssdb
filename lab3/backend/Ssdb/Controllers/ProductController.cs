using Microsoft.AspNetCore.Mvc;
using Ssdb.Model;

namespace Ssdb.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ProductController : ControllerBase
{
    private readonly DataProvider _dataProvider;

    public ProductController(DataProvider dataProvider) => _dataProvider = dataProvider;

    [HttpGet]
    public async Task<ActionResult<List<Product>>> GetProducts()
        => Ok(await _dataProvider.GetAllProductsAsync());

    [HttpGet("{id:int}", Name = nameof(GetProduct))]
    public async Task<ActionResult<Product>> GetProduct(int id)
    {
        var product = await _dataProvider.GetProductAsync(id);

        return product == null ? NotFound() : Ok(product);
    }

    // [HttpPost]
    // public async Task<ActionResult<Product>> CreateProduct([FromBody] Product product)
    // {
    //     if (product == null)
    //     {
    //         return BadRequest();
    //     }
    //
    //     var id = await _dataProvider.AddProductAsync(product);
    //     product.Id = id;
    //
    //     return CreatedAtRoute(nameof(GetProduct), new { id }, product);
    // }
    //
    // [HttpPut("{id:int}")]
    // public async Task<ActionResult<Product>> UpdateProduct(int id, [FromBody] Product product)
    // {
    //     if (product == null || id != product.Id)
    //     {
    //         return BadRequest();
    //     }
    //
    //     var existing = await _dataProvider.GetProductAsync(id);
    //     if (existing == null)
    //     {
    //         return NotFound();
    //     }
    //
    //     existing.ProductName = product.ProductName;
    //     existing.Department = product.Department;
    //     existing.Quantity = product.Quantity;
    //     existing.Price = product.Price;
    //     existing.Description = product.Description;
    //
    //     await _dataProvider.UpdateProductAsync(existing);
    //
    //     return Ok(existing);
    // }
    //
    // [HttpDelete("{id:int}")]
    // public async Task<IActionResult> DeleteProduct(int id)
    // {
    //     var existing = await _dataProvider.GetProductAsync(id);
    //     if (existing == null)
    //     {
    //         return NotFound();
    //     }
    //
    //     await _dataProvider.DeleteProductAsync(id);
    //
    //     return NoContent();
    // }
}
