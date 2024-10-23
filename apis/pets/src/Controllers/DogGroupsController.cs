using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PetsApi.Data;
using PetsApi.Models;

namespace PetsApi.Controllers
{
    [ApiController]
    [Route("dogs/groups")]
    public class DogGroupsController : ControllerBase
    {
        private readonly PetsDbContext _context;

        public DogGroupsController(PetsDbContext context)
        {
            _context = context;
        }

        [HttpGet(Name = "GetDogGroups")]
        public async Task<IEnumerable<DogGroup>> Get()
        {
            return await _context.DogGroups.ToListAsync();
        }

        [HttpGet("{id:int}", Name = "GetDogGroupById")]
        public async Task<ActionResult<DogGroup>> GetById(int id)
        {
            var dogGroup = await _context.DogGroups.FindAsync(id);
            if (dogGroup == null)
            {
                return NotFound();
            }
            return dogGroup;
        }

        [HttpGet("byname/{name}", Name = "GetDogGroupByName")]
        public async Task<ActionResult<DogGroup>> GetByName(string name)
        {
            var dogGroup = await _context.DogGroups.FirstOrDefaultAsync(dg => dg.Name == name);
            if (dogGroup == null)
            {
                return NotFound();
            }
            return dogGroup;
        }
    }
}