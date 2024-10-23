using Microsoft.AspNetCore.Mvc;
using CacheContentApi.Models;

namespace CacheContentApi.Controllers
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
