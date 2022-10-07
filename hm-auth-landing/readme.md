# Deploy the app to Azure Container Apps

Create a container registry.

```PowerShell
$rgName = "hm-python-func"
$acrName = "hmacr666"
az acr create --resource-group $rgName `
  --name $acrName --sku Basic
```

Log in to the registry.

```PowerShell
$acrName = "hmacr666"
az acr login --name $acrName
```

Build the container

```PowerShell
$imageName = "hmauthlanding"
docker build -t $imageName .
```

Create a tag for the image and push it to the registry.

```PowerShell
$acrServer = "hmacr666.azurecr.io"
$imageName = "hmauthlanding"
docker tag "$imageName" "$acrServer/$($imageName):latest"
docker push "$acrServer/$($imageName):latest"
```

Test the docker image locally

```PowerShell	
docker run -p 127.0.0.1:80:5067/tcp hmacr666.azurecr.io/hmauthlanding:latest
```

