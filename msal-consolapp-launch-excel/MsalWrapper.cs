// dotnet add package Microsoft.Identity.Client
// dotnet add package Microsoft.Identity.Client.Broker --prerelease
using Microsoft.Identity.Client;
using Microsoft.Identity.Client.Broker;
using System.Diagnostics;
using System.Runtime.InteropServices;


namespace MsalConsole
{

    internal class MsalWrapper
    {
        [DllImport("kernel32.dll", SetLastError = true)]
        static extern bool AttachConsole(uint dwProcessId);
        [DllImport("kernel32.dll")]
        static extern IntPtr GetConsoleWindow();
        [DllImport("kernel32.dll", SetLastError=true, ExactSpelling=true)]
        static extern bool FreeConsole();

        IPublicClientApplication? _clientApp = null;
        AuthenticationResult? _authResult = null;

        internal string AccessToken 
        {
            get 
            {
                if(_authResult != null)
                {
                    return _authResult.AccessToken;
                }
                else
                {
                    return string.Empty;
                }
            }
        }
        private void CreateApplication()
        {
            var builder = PublicClientApplicationBuilder.Create(Constants.ClientId)
                .WithAuthority($"{Constants.Instance}{Constants.Tenant}")
                .WithDefaultRedirectUri();

            //Use of Broker Requires redirect URI "ms-appx-web://microsoft.aad.brokerplugin/{client_id}" in app registration
            builder.WithBrokerPreview(true);
            
            _clientApp = builder.Build();
            TokenCacheHelper.EnableSerialization(_clientApp.UserTokenCache);
        }

        internal void AqcuireToken()
        {
            CreateApplication();

            
            var accounts = _clientApp.GetAccountsAsync().Result;

            if(accounts.Count<object>() > 0) {
                try
                {
                    _authResult = _clientApp.AcquireTokenSilent(Constants.scopes, accounts.FirstOrDefault())
                        .ExecuteAsync().Result;
                }
                catch (MsalUiRequiredException ex)
                {
                    try
                    {
                        _authResult = _clientApp.AcquireTokenInteractive(Constants.scopes)
                                        .ExecuteAsync().Result;
                    }
                    catch (MsalException msalex)
                    {
                        Console.WriteLine($"Error Acquiring Token:{System.Environment.NewLine}{msalex}");
                        throw;
                    }
                }
            }
            else
            {
                try
                {
                    IntPtr handle = GetConsoleWindow();
                    _authResult = _clientApp.AcquireTokenInteractive(Constants.scopes).WithParentActivityOrWindow(handle)
                                   .ExecuteAsync().Result;
                    Console.WriteLine($"hande: {handle}");
                }
                catch (MsalException msalex)
                {
                    Console.WriteLine($"Error Acquiring Token:{System.Environment.NewLine}{msalex}");
                    throw;
                }
            }
        }
    }
}