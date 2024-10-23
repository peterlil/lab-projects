using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using BoatsApi.Data;
using BoatsApi.Models;

namespace BoatsApi.Controllers
{
    [ApiController]
    [Route("boats/manufacturers")]
    public class BoatManufacturersController : ControllerBase
    {
        private readonly BoatsDbContext _context;

        public BoatManufacturersController(BoatsDbContext context)
        {
            _context = context;
        }

        [HttpGet(Name = "GetBoatManufacturers")]
        public async Task<IEnumerable<BoatManufacturer>> Get()
        {
            return await _context.BoatManufacturers.ToListAsync();
        }

        [HttpGet("{id:int}", Name = "GetBoatManufacturerById")]
        public async Task<ActionResult<BoatManufacturer>> GetById(int id)
        {
            var BoatManufacturer = await _context.BoatManufacturers.FindAsync(id);
            if (BoatManufacturer == null)
            {
                return NotFound();
            }
            return BoatManufacturer;
        }

        [HttpGet("byname/{name}", Name = "GetBoatManufacturerByName")]
        public async Task<ActionResult<BoatManufacturer>> GetByName(string name)
        {
            var BoatManufacturer = await _context.BoatManufacturers.FirstOrDefaultAsync(dg => dg.Name == name);
            if (BoatManufacturer == null)
            {
                return NotFound();
            }
            return BoatManufacturer;
        }
    }
}