using Azure.Identity;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Logging;

namespace az_func_timeout_vs
{
    public class HttpTimeout
    {
        private readonly ILogger<HttpTimeout> _logger;
        private readonly string _connectionString;

        public HttpTimeout(ILogger<HttpTimeout> logger)
        {
            _logger = logger;
            _logger.LogDebug("HttpTimeout constructor called.");
            _connectionString = Environment.GetEnvironmentVariable("SQLAZURECONNSTR_SqlConnectionString");
            if (string.IsNullOrEmpty(_connectionString))
            {
                _logger.LogError("SqlConnectionString environment variable is not set.");
            }
            _logger.LogDebug("HttpTimeout constructor exiting.");
        }

        [Function("HttpTimeout")]
        public async Task<IActionResult> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", "post")] HttpRequest req)
        {
            var appName = "az-func-timeout-vs:1";
            await DoWork(appName);

            _logger.LogInformation("C# HTTP trigger function processed a request.");
            return new OkObjectResult("Welcome to Azure Functions!");
        }

        private async Task DoWork(string appName)
        {
            try
            {
                //var tokenCredential = new DefaultAzureCredential();
                //var token = tokenCredential.GetToken(new Azure.Core.TokenRequestContext(new[] { "https://database.windows.net/.default" }));

                using (var connection = new SqlConnection(_connectionString))
                {
                    //connection.AccessToken = token.Token;
                    connection.Open();

                    var query = "INSERT INTO TimeoutLog (ApplicationName) VALUES (@ApplicationName)";
                    using (var command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@ApplicationName", appName);

                        for (int i = 0; i < 31 * 60; i++) // 31 minutes * 60 seconds
                        {
                            command.ExecuteNonQuery();
                            _logger.LogInformation($"App name logged successfully at {DateTime.Now}.");
                            await Task.Delay(1000); // Wait for 1 second
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error logging app name: {ex.Message}");
            }
        }
    }
}
