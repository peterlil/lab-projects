using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PetsApi.Data;
using PetsApi.Models;

namespace PetsApi.Controllers
{
    [ApiController]
    [Route("dogs")]
    public class DogsController : Controller
    {
        private readonly PetsDbContext _context;

        public DogsController(PetsDbContext context)
        {
            _context = context;
        }

        [HttpGet(Name = "GetDogs")]
        public async Task<IEnumerable<Dog>> Get()
        {
            return await _context.Dogs
                                 .Include(d => d.Breed)
                                 .ToListAsync();
        }

        [HttpGet("{id:int}", Name = "GetDogById")]
        public async Task<ActionResult<Dog>> GetById(int id)
        {
            var Dog = await _context.Dogs
                                         .Include(d => d.Breed)
                                         .ThenInclude(b => b.Group)
                                         .FirstOrDefaultAsync(b => b.Id == id);
            if (Dog == null)
            {
                return NotFound();
            }
            return Dog;
        }

        [HttpGet("byname/{name}", Name = "GetDogByName")]
        public async Task<ActionResult<Dog>> GetByName(string name)
        {
            var Dog = await _context.Dogs
                                         .Include(d => d.Breed)
                                         .ThenInclude(b => b.Group)
                                         .FirstOrDefaultAsync(dg => dg.Name == name);
            if (Dog == null)
            {
                return NotFound();
            }
            return Dog;
        }
    }
}
