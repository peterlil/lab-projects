using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System.Data;
// using System.Data.SqlClient;
using System.Diagnostics;
using System.Text;

public class Loader
{
    IConfiguration? _config = null;

    private void Initialize()
    {
        var env = Environment.GetEnvironmentVariable("DOTNET_ENVIRONMENT");
        _config = new ConfigurationBuilder()
            .AddJsonFile("appsettings.json", false, true)
            .AddJsonFile($"appsettings.{env}.json", true, true)
            .AddEnvironmentVariables()
            .Build();
    }
    public void PrepareData() 
    {
        if(_config == null)
        {
            Initialize();
        }
        
        Debug.Assert(_config != null);

        if(_config == null)
        {
            Console.WriteLine("Configuration is null, exiting.");
            return;
        }
        var connectionString = _config.GetConnectionString("DefaultConnection");
        using (SqlConnection dbConnection = new SqlConnection(connectionString))
        {
            dbConnection.Open();
        
            var dt = new DataTable("MyTable");
            dt.Columns.Add("Article", typeof(string));
            dt.Columns.Add("PlanningMarket", typeof(string));
            dt.Columns.Add("Calendarweek", typeof(string));
            dt.Columns.Add("StockPieces", typeof(int));
            dt.Columns.Add("AccumulatedStoickPieces", typeof(int));
            dt.Columns.Add("StockGrossPMC", typeof(decimal));


            var chunkSize = 1000000;
            var chunk = new string[chunkSize];
            for(int i = 0; i < 100000000; i++)
            {
                /*
                Article_BusinessKey varchar(20) NOT NULL,
                PlanningMarket_BusinessKey varchar(4) NOT NULL,
                Calendarweek_BusinessKey char(6) NOT NULL,
                StockPieces int NOT NULL,
                AccumulatedStoickPieces int NOT NULL,
                StockGrossPMC decimal (19,9) NOT NULL,
                */
                DataRow dr = dt.NewRow();
                dr["Article"] = string.Format("{0};{1,7:D7};{2,3:D3}", 
                                                RandomHelper.GetRandomNumber(2022, 2025)*100 + RandomHelper.GetRandomNumber(1, 12),
                                                RandomHelper.GetRandomNumber(0, 9999999),
                                                RandomHelper.GetRandomNumber(1, 20));
                dr["PlanningMarket"] = string.Format("{0,4}", RandomHelper.GetRandomNumber(1000, 1200));
                dr["Calendarweek"] = RandomHelper.GetRandomNumber(2022, 2025)*100 + RandomHelper.GetRandomNumber(1, 52);
                dr["StockPieces"] = 1;
                dr["AccumulatedStoickPieces"] = 1;
                dr["StockGrossPMC"] = 1.0;

                dt.Rows.Add(dr);

                if( i % chunkSize == chunkSize - 1)
                {
                    using (SqlBulkCopy bulkCopy =
                           new SqlBulkCopy(dbConnection))
                    {
                        bulkCopy.DestinationTableName = "dbo.MyTable";

                        try
                        {
                            // Write from the source to the destination.
                            bulkCopy.WriteToServer(dt);
                            dt.Rows.Clear();
                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine(ex.Message);
                        }
                    }
                    Console.WriteLine("Inserted {0} rows", i+1);
                }
            }
        }
    }
}
