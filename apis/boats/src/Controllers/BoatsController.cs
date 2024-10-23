using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using BoatsApi.Data;
using BoatsApi.Models;

namespace BoatsApi.Controllers
{
    [ApiController]
    [Route("boats")]
    public class BoatsController : Controller
    {
        private readonly BoatsDbContext _context;

        public BoatsController(BoatsDbContext context)
        {
            _context = context;
        }

        [HttpGet(Name = "GetBoats")]
        public async Task<IEnumerable<Boat>> Get()
        {
            return await _context.Boats
                                 .Include(d => d.Model)
                                 .ToListAsync();
        }

        [HttpGet("{id:int}", Name = "GetBoatById")]
        public async Task<ActionResult<Boat>> GetById(int id)
        {
            var Boat = await _context.Boats
                                         .Include(d => d.Model)
                                         .ThenInclude(b => b.Manufacturer)
                                         .FirstOrDefaultAsync(b => b.Id == id);
            if (Boat == null)
            {
                return NotFound();
            }
            return Boat;
        }

        [HttpGet("byname/{name}", Name = "GetBoatByName")]
        public async Task<ActionResult<Boat>> GetByName(string name)
        {
            var Boat = await _context.Boats
                                         .Include(d => d.Model)
                                         .ThenInclude(b => b.Manufacturer)
                                         .FirstOrDefaultAsync(dg => dg.Name == name);
            if (Boat == null)
            {
                return NotFound();
            }
            return Boat;
        }
    }
}
