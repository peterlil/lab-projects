using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.DurableTask;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace Microsoft.peterlil
{
    [JsonObject(MemberSerialization.OptIn)]
    public class DurableFunctions1
    {
        ILogger _log;

        [JsonProperty("value")]
        public string Value { get; set; }

        public void Add(string appendString) 
        {
            this.Value += appendString;
        }

        public Task Reset() 
        {
            this.Value = string.Empty;
            return Task.CompletedTask;
        }

        public Task<string> Get() 
        {
            return Task.FromResult(this.Value);
        }

        public void Delete() 
        {
            Entity.Current.DeleteState();
        }

        [FunctionName("DurableFunctions1")]
        public static Task Run([EntityTrigger] IDurableEntityContext context)
            => context.DispatchAsync<DurableFunctions1>();
    }
}