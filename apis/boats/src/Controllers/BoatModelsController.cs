using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using BoatsApi.Data;
using BoatsApi.Models;

namespace BoatsApi.Controllers
{
    [ApiController]
    [Route("boats/models")]
    public class BoatModelsController : ControllerBase
    {
        private readonly BoatsDbContext _context;

        public BoatModelsController(BoatsDbContext context)
        {
            _context = context;
        }

        [HttpGet(Name = "GetBoatModels")]
        public async Task<IEnumerable<BoatModel>> Get()
        {
            return await _context.BoatModels
                                 .Include(b => b.Manufacturer)
                                 .ToListAsync();
        }

        [HttpGet("{id:int}", Name = "GetBoatModelById")]
        public async Task<ActionResult<BoatModel>> GetById(int id)
        {
            var BoatModel = await _context.BoatModels
                                         .Include(b => b.Manufacturer)
                                         .FirstOrDefaultAsync(b => b.Id == id);
            if (BoatModel == null)
            {
                return NotFound();
            }
            return BoatModel;
        }

        [HttpGet("byname/{name}", Name = "GetBoatModelByName")]
        public async Task<ActionResult<BoatModel>> GetByName(string name)
        {
            var BoatModel = await _context.BoatModels
                                         .Include(b => b.Manufacturer)
                                         .FirstOrDefaultAsync(dg => dg.Name == name);
            if (BoatModel == null)
            {
                return NotFound();
            }
            return BoatModel;
        }
    }
}
