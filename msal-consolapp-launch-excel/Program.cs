// Used these packages
// dotnet add package Microsoft.Identity.Client
// dotnet add package Microsoft.Identity.Client.Broker --prerelease
//dotnet add package System.Security.Cryptography.ProtectedData --version 6.0.0

using MsalConsole;

// See https://aka.ms/new-console-template for more information
Console.WriteLine("Hello, World!");

MsalWrapper msalWrapper = new MsalWrapper();
msalWrapper.AqcuireToken();

Console.WriteLine(msalWrapper.AccessToken);


