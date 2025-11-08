# --- fill these ---
$Owner  = "rare-beauty"   # organisation name
$SUB = "4660c4f3-a83c-406e-8741-d1067921120b"
$Branch = "main"                 # staging branch 
$AppId  = "ba3891bd-8a09-4e26-b09a-8d58a5661a95"        # the appId (clientId) you already have
$Name   = "github-oidc-env-production" # any short name

# (login first if needed)
az login 
az account set --subscription $SUB

# Get the App Object Id from the App Id
$AppObjectId = az ad app show --id $AppId --query id -o tsv

#  Create federated credential (inline JSON)
@"
{
  "name": "$Name",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "repo:$Owner/makeup-website:environment:production",
  "audiences": ["api://AzureADTokenExchange"]
}
"@ | Set-Content -Path "fc-env-production.json" -Encoding utf8

# create the federated credential (NO @ before filename)
az ad app federated-credential create --id $AppObjectId --parameters "fc-env-production.json"
# verify
az ad app federated-credential list --id $AppObjectId -o table