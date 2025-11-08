# --- fill these ---
$Owner  = "rare-beauty"   # organisation name

$Branch = "dev"                 # staging branch 
$AppId  = "53b0d08d-b186-40c2-8e4d-c9a3d3619e59"        # the appId (clientId) you already have
$Name   = "github-oidc-env-staging" # any short name

# (login first if needed)
az login 
az account set --subscription 4660c4f3-a83c-406e-8741-d1067921120b

# Get the App Object Id from the App Id
$AppObjectId = az ad app show --id $AppId --query id -o tsv

#  Create federated credential (inline JSON)
@"
{
  "name": "$Name",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "repo:$Owner/makeup-website:environment:staging",
  "audiences": ["api://AzureADTokenExchange"]
}
"@ | Set-Content -Path "fc-env-staging.json" -Encoding utf8

# create the federated credential (NO @ before filename)
az ad app federated-credential create --id $AppObjectId --parameters "fc-env-staging.json"

# verify
az ad app federated-credential list --id $AppObjectId -o table