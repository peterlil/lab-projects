# Helper scripts for the project

## Build the image and run the project locally as a container

```powershell
$rootPath = "C:\src\github\peterlil\lab-projects\apis\pets\src"
$registry = "plapis"
$repository = "petsapi"
$imageBaseName = "petsapi"
$tag = "1.0"

cd $rootPath

# Set Docker log level to debug
#$env:DOCKER_BUILDKIT = 1
#$env:DOCKER_CLI_LOG = "debug"

# build the image
docker build -t "${imageBaseName}:$tag" . # --progress=plain

# tag the image
docker tag "${imageBaseName}:$tag" "${registry}.azurecr.io/${imageBaseName}:${tag}"

# run the container
docker run -d `
    -p 8443:443 `
    -e ASPNETCORE_ENVIRONMENT=DockerDevelopment `
    -e ASPNETCORE_Kestrel__Certificates__Default__Password="scAm1()3@WCz5sSKVI82" `
    -e ASPNETCORE_Kestrel__Certificates__Default__Path=/https/petsapi-dev.peterlabs.net.pfx `
    -v $env:USERPROFILE\.aspnet\https:/https/ `
    --name $imageBaseName `
    "${imageBaseName}:${tag}"


```

## Build the image and push it to the container registry

```powershell
$rootPath = "C:\src\github\peterlil\lab-projects\apis\pets\src"
$registry = "plapis"
$repository = "petsapi"
$imageBaseName = "petsapi"
$tag = "1.6"

cd $rootPath

# build the image
docker build -t "${imageBaseName}:$tag" .

# tag the image
docker tag "${imageBaseName}:$tag" "${registry}.azurecr.io/${imageBaseName}:${tag}"

# Login to Azure Container Registry
#az acr login --name $registry

# Push the image to Azure Container Registry
docker push "${registry}.azurecr.io/${imageBaseName}:${tag}"

   
# docker system prune -f
```

## Development Environment

### Creating self-signed SSL certificates for local debugging

This works in Windows, MacOS, and Linux. The certificate is created in the user's profile folder.
```powershell
# Create a new self-signed certificate
dotnet dev-certs https --trust
```

## DT(AP) environments

### Create certificates for DTAP environments using WSL, ACME.SH and Let's Encrypt

This works in Linux and WSL.
```bash
# Add the service principal information to .bashrc
nano ~/.bashrc

# Install acme.sh
curl https://get.acme.sh | sh

# Create a new certificate
~/.acme.sh/acme.sh --force --issue --dns dns_azure -d petsapi-dev.peterlabs.net

# Create pfx
password='scAm1()3@WCz5sSKVI82'
acme.sh --toPkcs -d petsapi-dev.peterlabs.net --password $password
cp /home/linuxpl/.acme.sh/petsapi-dev.peterlabs.net_ecc/petsapi-dev.peterlabs.net.pfx /mnt/c/src/github/peterlil/lab-projects/apis/pets/src
```

### Validate the certificate
```powershell
$Path = "C:\src\github\peterlil\lab-projects\apis\pets\src\petsapi-dev.peterlabs.net.pfx"
$Password = "scAm1()3@WCz5sSKVI82"

try {
    # Attempt to load the certificate using the constructor
    $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($Path, $Password)
    Write-Output "Certificate loaded successfully."
    return $true
} catch {
    Write-Error "Failed to load certificate: $_"
    return $false
}

$Path = "C:\src\github\peterlil\lab-projects\apis\pets\src\petsapi-dev.peterlabs.net-easy.pfx"
try {
    # Attempt to load the certificate using the constructor
    $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($Path, "mysimplepwd")
    Write-Output "Certificate loaded successfully."
    return $true
} catch {
    Write-Error "Failed to load certificate: $_"
    return $false
}
```
