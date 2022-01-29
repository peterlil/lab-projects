using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Azure.WebJobs.Extensions.DurableTask;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace Microsoft.peterlil
{
    public static class JoinBlobFileContent
    {
        [FunctionName("JoinBlobFileContent")]
        public static void Run(
            [BlobTrigger("samples-workitems/{name}", Connection = "peterliltestdata_STORAGE")]Stream myBlob, 
            [DurableClient] IDurableEntityClient client,
            string name, 
            ILogger log)
        {
            log.LogInformation($"C# Blob trigger function Processed blob\n Name:{name} \n Size: {myBlob.Length} Bytes");
            // Entity operation input comes from the queue message content.
            var entityId = new EntityId(nameof(DurableFunctions1), "myEntity");
            string fileName = name;
            const int MAX_READ = 100;
            byte[] buffer = new byte[myBlob.Length];
            Task<int> readResultTask = myBlob.ReadAsync(buffer, 0, myBlob.Length);
            readResultTask.Wait();
            string content = System.Text.Encoding.ASCII.GetString(buffer);

            // Get the before state
            Task<EntityStateResponse<JObject>> t = client.ReadEntityStateAsync<JObject>(entityId);
            t.Wait();
            EntityStateResponse<JObject> stateResponse = t.Result;
            log.LogInformation($"Entity state before: {stateResponse.EntityState}");

            // Store the new value
            client.SignalEntityAsync(entityId, "Add", content).Wait();
            
            // Get the after state
            t = client.ReadEntityStateAsync<JObject>(entityId);
            t.Wait();
            stateResponse = t.Result;
            log.LogInformation($"Entity state after: {stateResponse.EntityState}");
            
            
        }
    }
}
