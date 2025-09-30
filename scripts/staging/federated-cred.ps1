# --- fill these ---
$Owner  = "rare-beauty"   # organisation name

$Branch = "dev"                 # staging branch 
$AppId  = "7e545c24-99fc-4ac5-8a03-a7916dde8bff"        # the appId (clientId) you already have
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
"@ | Set-Content -Path "federated-dev.json" -Encoding utf8

# create the federated credential (NO @ before filename)
az ad app federated-credential create --id $AppObjectId --parameters "federated-dev.json"

# verify
az ad app federated-credential list --id $AppObjectId -o table