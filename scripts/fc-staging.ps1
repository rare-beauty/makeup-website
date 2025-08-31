# Your existing app (Client ID) used by the staging environment
$APP_CLIENT_ID = "5f676da1-13cf-4c8a-8b77-9765d50963c4"

# Get its *object id* (different from client/app id)
$APP_OBJECT_ID = az ad app show --id $APP_CLIENT_ID --query id -o tsv

# Create the federated credential (subject must match your GitHub Environment name)
$fc = @{
  name      = "gh-env-staging"
  issuer    = "https://token.actions.githubusercontent.com"
  subject   = "repo:rare-beauty/makeup-website:environment:staging"
  audiences = @("api://AzureADTokenExchange")
} | ConvertTo-Json -Compress

$tmp = New-TemporaryFile
$fc | Out-File $tmp -Encoding utf8
az ad app federated-credential create --id $APP_OBJECT_ID --parameters "@$tmp"
Remove-Item $tmp

# Verify
az ad app federated-credential list --id $APP_OBJECT_ID --query "[].{name:name,subject:subject}" -o table
