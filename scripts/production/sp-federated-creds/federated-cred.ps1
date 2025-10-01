# --- fill these ---
$Owner  = "rare-beauty"   # organisation name

$Branch = "main"                 # staging branch 
$AppId  = "4fb5c823-3659-4a56-a2e3-d18987b247ae"        # the appId (clientId) you already have
$Name   = "github-oidc-$Branch" # any short name

# (login first if needed)
az login 
az account set --subscription 545d4a9b-b402-4493-a10a-99d17130d280

# Get the App Object Id from the App Id
$AppObjectId = az ad app show --id $AppId --query id -o tsv

#  Create federated credential (inline JSON)
@"
{
  "name": "$Name",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "repo:$Owner/makeup-website:ref:refs/heads/$Branch",
  "audiences": ["api://AzureADTokenExchange"]
}
"@ | Set-Content -Path "federated-main.json" -Encoding utf8

# create the federated credential (NO @ before filename)
az ad app federated-credential create --id $AppObjectId --parameters "federated-main.json"

# verify
az ad app federated-credential list --id $AppObjectId -o table