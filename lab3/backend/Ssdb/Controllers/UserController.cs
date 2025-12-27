using Microsoft.AspNetCore.Mvc;
using Ssdb.Model;

namespace Ssdb.Controllers;

[ApiController]
[Route("api/[controller]")]
public class UserController : ControllerBase
{
    private readonly DataProvider _dataProvider;

    public UserController(DataProvider dataProvider) => _dataProvider = dataProvider;

    [HttpGet]
    public async Task<ActionResult<List<User>>> GetUsers()
        => Ok(await _dataProvider.GetAllUsersAsync());

    [HttpGet("{id:int}", Name = nameof(GetUser))]
    public async Task<ActionResult<User>> GetUser(int id)
    {
        var user = await _dataProvider.GetUserAsync(id);
        
        return user == null ? NotFound() : Ok(user);
    }
    //
    // [HttpPost]
    // public async Task<ActionResult<User>> CreateUser([FromBody] User user)
    // {
    //     if (user == null)
    //     {
    //         return BadRequest();
    //     }
    //
    //     var id = await _dataProvider.AddUserAsync(user);
    //     user.Id = id;
    //
    //     return CreatedAtRoute(nameof(GetUser), new { id }, user);
    // }
    //
    // [HttpPut("{id:int}")]
    // public async Task<ActionResult<User>> UpdateUser(int id, [FromBody] User user)
    // {
    //     if (user == null || id != user.Id)
    //     {
    //         return BadRequest();
    //     }
    //
    //     var existing = await _dataProvider.GetUserAsync(id);
    //     if (existing == null)
    //     {
    //         return NotFound();
    //     }
    //
    //     existing.FullName = user.FullName;
    //     existing.Email = user.Email;
    //     existing.Phone = user.Phone;
    //
    //     await _dataProvider.UpdateUserAsync(existing);
    //
    //     return Ok(existing);
    // }
    //
    // [HttpDelete("{id:int}")]
    // public async Task<IActionResult> DeleteUser(int id)
    // {
    //     var existing = await _dataProvider.GetUserAsync(id);
    //     if (existing == null)
    //     {
    //         return NotFound();
    //     }
    //
    //     await _dataProvider.DeleteUserAsync(id);
    //
    //     return NoContent();
    // }
}
