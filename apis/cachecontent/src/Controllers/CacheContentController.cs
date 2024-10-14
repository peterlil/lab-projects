using Microsoft.AspNetCore.Mvc;
using CacheContentApi.Models;

namespace CacheContentApi.Controllers
{
    [ApiController]
    [Route("cache/content")]
    public class CacheContentController : ControllerBase
    {
        [HttpGet(Name = "GetCacheContent")]
        public async Task<IEnumerable<KeyValuePair<string, string>>> Get()
        {
            var cacheContent = new List<KeyValuePair<string, string>>();

            // create a list of cache content with seven hardcoded items
            cacheContent.Add(new KeyValuePair<string, string>("locale-sv_se", "eu1"));
            cacheContent.Add(new KeyValuePair<string, string>("locale-en_gb", "eu2"));
            cacheContent.Add(new KeyValuePair<string, string>("locale-de_de", "eu3"));
            cacheContent.Add(new KeyValuePair<string, string>("locale-es_es", "eu4"));
            cacheContent.Add(new KeyValuePair<string, string>("locale-fr_fr", "eu5"));
            cacheContent.Add(new KeyValuePair<string, string>("locale-en_us", "am"));
            cacheContent.Add(new KeyValuePair<string, string>("locale-en_in", "ap"));

            // create a list of cache content for services
            cacheContent.Add(new KeyValuePair<string, string>("sv_se-sortiment", "assortment"));
            cacheContent.Add(new KeyValuePair<string, string>("sv_se-sök", "search"));
            cacheContent.Add(new KeyValuePair<string, string>("sv_se-kassa", "checkout"));
            cacheContent.Add(new KeyValuePair<string, string>("sv_se-kundvagn", "cart"));
            cacheContent.Add(new KeyValuePair<string, string>("sv_se-kundservice", "customer-service"));

            return await Task.FromResult(cacheContent);
        }
    }
}