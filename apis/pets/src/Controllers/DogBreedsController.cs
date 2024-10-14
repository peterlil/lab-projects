using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PetsApi.Data;
using PetsApi.Models;

namespace PetsApi.Controllers
{
    [ApiController]
    [Route("dogs/breeds")]
    public class DogBreedsController : ControllerBase
    {
        private readonly PetsDbContext _context;

        public DogBreedsController(PetsDbContext context)
        {
            _context = context;
        }

        [HttpGet(Name = "GetDogBreeds")]
        public async Task<IEnumerable<DogBreed>> Get()
        {
            return await _context.DogBreeds
                                 .Include(b => b.Group)
                                 .ToListAsync();
        }

        [HttpGet("{id:int}", Name = "GetDogBreedById")]
        public async Task<ActionResult<DogBreed>> GetById(int id)
        {
            var DogBreed = await _context.DogBreeds
                                         .Include(b => b.Group)
                                         .FirstOrDefaultAsync(b => b.Id == id);
            if (DogBreed == null)
            {
                return NotFound();
            }
            return DogBreed;
        }

        [HttpGet("byname/{name}", Name = "GetDogBreedByName")]
        public async Task<ActionResult<DogBreed>> GetByName(string name)
        {
            var DogBreed = await _context.DogBreeds
                                         .Include(b => b.Group)
                                         .FirstOrDefaultAsync(dg => dg.Name == name);
            if (DogBreed == null)
            {
                return NotFound();
            }
            return DogBreed;
        }
    }
}
