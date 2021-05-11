using System;
using System.Collections.Generic;
using System.IO;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Azure.EventGrid;
using Microsoft.Azure.EventGrid.Models;
using Microsoft.Extensions.Logging;

// NuGet required: https://www.nuget.org/packages/Microsoft.Azure.EventGrid/

namespace Peterlabs.FunctionTest1
{
    public static class BlobProcessor
    {
        [FunctionName("BlobProcessor")]
        public static void Run([BlobTrigger("af-test1-drop/{name}", Connection = "azfunctest1_STORAGE")]Stream myBlob, string name, ILogger log)
        {
            log.LogInformation($"C# Blob trigger function Processed blob\n Name:{name} \n Size: {myBlob.Length} Bytes");


            var testEvent = new EventGridEvent()
            {
                Id = Guid.NewGuid().ToString(),
                Subject = "Test Event",
                EventType = "test-event-type",
                EventTime = DateTime.UtcNow,
                Data = name,
                DataVersion = "1.0"
            };

            var topicHostname = new Uri("https://peterlileventgridtopic1.northeurope-1.eventgrid.azure.net/api/events").Host;
            var topicCredentials = new TopicCredentials("<thekey>");
            var client = new EventGridClient(topicCredentials);

            client.PublishEventsAsync(topicHostname, new List<EventGridEvent>() { testEvent });
        }
    }
}
