# Continuous Delivery

Create the service principal for the workflow.

```PowerShell
$appregName = "funcapi-python-flask-cd"
$subscriptionId = (az account show --query "id" -o tsv)

az ad sp create-for-rbac --name $appregName --role contributor `
    --scopes "/subscriptions/$($subscriptionId)" `
    --sdk-auth
```