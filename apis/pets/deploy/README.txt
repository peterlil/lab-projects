# Deployment commands for bicep files in this folder

```powershell
$rg = 'apis'
$location = 'northeurope'
$envName = 'apis-cappenv'
$lawsName = 'laws-ne'
$lawsRg = 'apim'

az deployment group create `
  --name "main-pre-$(Get-Date -Format 'yyyyMMddThhmm')" `
  --resource-group $rg `
  --template-file .\main.bicep `
  -p `
    location=$location `
    envName=$envName `
    lawsName=$lawsName `
    lawsRg=$lawsRg
```