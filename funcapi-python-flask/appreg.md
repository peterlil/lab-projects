# App Registration

```PowerShell
$appDisplayName='funcapi-python-flask-no-secret'
$tenantName='fdpo'
$redirectUris = "https://hm-auth-landing.yellowocean-78582576.eastus.azurecontainerapps.io"

$appReg = az ad app create --display-name $appDisplayName `
    --web-redirect-uris $redirectUris `
    --identifier-uris "https://$($appDisplayName).$($tenantName).onmicrosoft.com" `
    --sign-in-audience AzureADMyOrg

$appReg

# Don't set credentials. Test the SPA way instead.
# az ad app credential reset --id "08a8d261-c594-45f8-9028-f20170adf5fd" --display-name "client secret" --append
```