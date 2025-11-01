using Microsoft.AspNetCore.Mvc;

namespace Ssdb.Controllers;

[ApiController]
[Route("api/[controller]")]
public class UserController : ControllerBase
{
    private DataProvider _dataProvider;

    public UserController(DataProvider dataProvider) => _dataProvider = dataProvider;

    [HttpGet]
    public async Task<ActionResult<List<User>>> GetUsers() 
        => Ok(await _dataProvider.GetAllUsersAsync());

    [HttpGet("{id}", Name = "GetUser")]
    public async Task<ActionResult<User>> GetUser(int id)
    {
        var user = await _dataProvider.GetUserByIdAsync(id);
        
        if (user == null)
        {
            return NotFound();
        }

        return Ok(user);
    }

[HttpPost]
public async Task<ActionResult<User>> CreateUser([FromForm] CreateUserDto userDto)
{
    if (userDto == null)
    {
        return BadRequest(new ProblemDetails { Title = "Invalid user data" });
    }
    var user = new User()
    {
        FirstName = userDto.FirstName,
        LastName = userDto.LastName,
        Email = userDto.Email,
        PhoneNumber = userDto.PhoneNumber,
        Password = userDto.Password,
        Role = userDto.Role,
        Address = userDto.Address,
    };

    try
    {
        int id = await _dataProvider.AddUserAsync(user);
        user.Id = id;
        
        return CreatedAtRoute("GetUser", new { Id = id }, user);
    }
    catch (Exception e)
    {
        return BadRequest(new ProblemDetails { Title = "Problem creating new user" });
    }
}

    [HttpPut]
    public async Task<ActionResult<User>> UpdateUser([FromForm] User userDto)
    {
        if (userDto == null)
        {
            return BadRequest(new ProblemDetails { Title = "Invalid user data" });
        }
        var user = await _dataProvider.GetUserByIdAsync(userDto.Id);

        if (user == null)
        {
            return NotFound();
        }

        user.FirstName = userDto.FirstName;
        user.LastName = userDto.LastName;
        user.Email = userDto.Email;
        user.PhoneNumber = userDto.PhoneNumber;
        user.Password = userDto.Password;
        user.Role = userDto.Role;
        user.Address = userDto.Address;

        try
        {
            await _dataProvider.UpdateUserAsync(user);
        }
        catch (Exception e)
        {
            return BadRequest(new ProblemDetails { Title = "Problem updating user" });
        }

        return Ok(user);
    }

    [HttpDelete("{id}")]
    public async Task<ActionResult> DeleteUser(int id)
    {
        await _dataProvider.DeleteUserAsync(id);
        
        return Ok();
    }


}
