namespace MsalConsole
{
    internal class Constants 
    {
        //public const string Tenant = "16b3c013-d300-468d-ac64-7eda0820b6d3"; // Microsoft non-prod tenant
        //public const string ClientId = "bf14828b-a3c0-4bda-bb35-42bc07eed4bf"; // peterlil-wpf-app
        public static string Instance = "https://login.microsoftonline.com/";
        
        //public static string[] scopes = new string[] { "user.read" }; // The scope for API call to user.read
        
        //public const string ClientId = "df73c213-eb7a-466b-ae63-4d216c803eed"; // funcapi-python-flask-no-secret
        //public static string[] scopes = new string[] { "user_impersonation" }; // The scope for API call to user_impersonation
        //public static string[] scopes = new string[] { "https://funcapi_python_flask.fdpo.onmicrosoft.com/user_impersonation" }; // The scope for API call to user_impersonation
        

        public const string Tenant = "7bcae91a-4325-4821-84b1-aac9d5caaa22"; // Microsoft non-prod tenant
        public const string ClientId = "ac13dfc5-345b-49b8-bfd0-76e549aab3fb"; // funcapi-python-flask-no-secret
        public static string[] scopes = new string[] { "https://funcapi-python-flask-api.MngEnv319828.onmicrosoft.com/user_impersonation" }; // The scope for API call to user_impersonation
        

    }
}