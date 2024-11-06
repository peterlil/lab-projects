# PetsGraphql

## Setting up the environment

## Development environment

### Setting up the CosmosDB Emulator

#### Prerequisites

* Docker in Windows

#### Configuring

Following the instructions in [this article](https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-develop-emulator?tabs=docker-linux%2Ccsharp&pivots=api-nosql) and authentication credentials are located [here](https://learn.microsoft.com/en-us/azure/cosmos-db/emulator).

Make sure _Docker Desktop_ is started. 

```PowerShell
# Pull down the image
docker pull mcr.microsoft.com/cosmosdb/linux/azure-cosmos-emulator:latest
# Make sure the image is there
docker images

# Start the emulator
$parameters = @(
    "--publish", "8081:8081"
    "--publish", "10250-10255:10250-10255"
    "--name", "cosmosdb-emulator"
    "--detach"
)
docker run @parameters mcr.microsoft.com/cosmosdb/linux/azure-cosmos-emulator:latest

# Download the certificate
$parameters = @{
    Uri = 'https://localhost:8081/_explorer/emulator.pem'
    Method = 'GET'
    OutFile = 'emulatorcert.crt'
    SkipCertificateCheck = $True
}
Invoke-WebRequest @parameters

# Install the certificate to trust it
$parameters = @{
    FilePath = 'emulatorcert.crt'
    CertStoreLocation = 'Cert:\CurrentUser\Root'
}
Import-Certificate @parameters
```

Navigate to `https://localhost:8081/_explorer/index.html` to access the data explorer. You might need to restart the browser for the certificate import to take effect. 

