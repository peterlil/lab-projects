# App Registration

## To use with single account

```PowerShell
$appDisplayName='funcapi-python-flask-no-secret'
$tenantName='fdpo'
$redirectUris = "https://localhost"

$appReg = az ad app create --display-name $appDisplayName `
    --web-redirect-uris $redirectUris `
    --identifier-uris "https://$($appDisplayName).$($tenantName).onmicrosoft.com" `
    --sign-in-audience AzureADMyOrg

$appReg

# Don't set credentials. Test the SPA way instead.
# az ad app credential reset --id "08a8d261-c594-45f8-9028-f20170adf5fd" --display-name "client secret" --append
```


## To use with two accounts

```PowerShell
# The API App
$apiAppDisplayName='funcapi-python-flask-api'
$apiAppTenantName='MngEnv319828'
$apiAppRedirectUris = "https://localhost"

$apiAppReg = az ad app create --display-name $apiAppDisplayName `
    --identifier-uris "https://$($apiAppDisplayName).$($apiAppTenantName).onmicrosoft.com" `
    --sign-in-audience AzureADMyOrg

# The client app
$clientAppDisplayName='funcapi-python-flask-client'
$clientAppTenantName='MngEnv319828'
$clientAppRedirectUris = "https://localhost"

$clientAppReg = az ad app create --display-name $clientAppDisplayName `
    --public-client-redirect-uris $clientAppRedirectUris `
    --sign-in-audience AzureADMyOrg


# Don't set credentials. Test the SPA way instead.
# az ad app credential reset --id "08a8d261-c594-45f8-9028-f20170adf5fd" --display-name "client secret" --append
```

Changed manifest for both api and client:
```"accessTokenAcceptedVersion": null -> "accessTokenAcceptedVersion": 2```