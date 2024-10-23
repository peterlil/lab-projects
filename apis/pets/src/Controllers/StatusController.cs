using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PetsApi.Models;

namespace PetsApi.Controllers
{
    [ApiController]
    [Route("status")]
    public class StatusController : ControllerBase
    {
        [HttpGet(Name = "GetStatus")]
        public async Task<IEnumerable<Status>> Get()
        {
            // return a list of one status object
            return new List<Status> { new Status { BasicsIsHealthy = true } };
        }
    }
}
