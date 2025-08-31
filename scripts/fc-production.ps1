# Your existing app (Client ID) used by the staging environment
$APP_CLIENT_ID = "dcf5697c-5814-4fcb-b2ed-9d20b703b742"

# Get its *object id* (different from client/app id)
$APP_OBJECT_ID = az ad app show --id $APP_CLIENT_ID --query id -o tsv

# Create the federated credential (subject must match your GitHub Environment name)
$fc = @{
  name      = "gh-env-production"
  issuer    = "https://token.actions.githubusercontent.com"
  subject   = "repo:rare-beauty/makeup-website:environment:production"
  audiences = @("api://AzureADTokenExchange")
} | ConvertTo-Json -Compress

$tmp = New-TemporaryFile
$fc | Out-File $tmp -Encoding utf8
az ad app federated-credential create --id $APP_OBJECT_ID --parameters "@$tmp"
Remove-Item $tmp

# Verify
az ad app federated-credential list --id $APP_OBJECT_ID --query "[].{name:name,subject:subject}" -o table
