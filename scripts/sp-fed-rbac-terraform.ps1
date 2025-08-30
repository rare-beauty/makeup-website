# ===== EDIT ONLY THESE =====
$ORG = "rare-beauty"
$REPO = "makeup-website"
$SUBSCRIPTION_ID = "0aebd59b-0fa7-463c-b58d-3596e3b848ea"
$SCOPE = "/subscriptions/$SUBSCRIPTION_ID"   # je RG level chahida, ethe RG scope likho
# ===========================

az account set --subscription $SUBSCRIPTION_ID
$TENANT_ID = az account show --query tenantId -o tsv

# -------- PROD (environment: production, branch: main) --------
$PROD_APP_ID   = az ad app create --display-name "terraform-prod" --query appId -o tsv
az ad sp create --id $PROD_APP_ID | Out-Null
$PROD_SP_OBJID = az ad sp show --id $PROD_APP_ID --query id -o tsv

az role assignment create `
  --assignee-object-id $PROD_SP_OBJID `
  --assignee-principal-type ServicePrincipal `
  --role "Contributor" `
  --scope $SCOPE | Out-Null

$prodJson = @{
  name      = "github-env-production"
  issuer    = "https://token.actions.githubusercontent.com"
  subject   = "repo:$ORG/$REPO:environment:production"   # <-- GitHub Environment name
  audiences = @("api://AzureADTokenExchange")
} | ConvertTo-Json -Compress
$prodFile = New-TemporaryFile
$prodJson | Out-File $prodFile -Encoding utf8
az ad app federated-credential create --id $(az ad app show --id $PROD_APP_ID --query id -o tsv) --parameters "@$prodFile" | Out-Null
Remove-Item $prodFile -Force

# -------- STAGING (environment: staging, branch: dev) --------
$STG_APP_ID   = az ad app create --display-name "terraform-staging" --query appId -o tsv
az ad sp create --id $STG_APP_ID | Out-Null
$STG_SP_OBJID = az ad sp show --id $STG_APP_ID --query id -o tsv

az role assignment create `
  --assignee-object-id $STG_SP_OBJID `
  --assignee-principal-type ServicePrincipal `
  --role "Contributor" `
  --scope $SCOPE | Out-Null

$stgJson = @{
  name      = "github-env-staging"
  issuer    = "https://token.actions.githubusercontent.com"
  subject   = "repo:$ORG/$REPO:environment:staging"       # <-- GitHub Environment name
  audiences = @("api://AzureADTokenExchange")
} | ConvertTo-Json -Compress
$stgFile = New-TemporaryFile
$stgJson | Out-File $stgFile -Encoding utf8
az ad app federated-credential create --id $(az ad app show --id $STG_APP_ID --query id -o tsv) --parameters "@$stgFile" | Out-Null
Remove-Item $stgFile -Force

# -------- PRINT THESE FOR GITHUB SECRETS --------
"`n==== Add as Environment secrets in GitHub ===="
"AZURE_TENANT_ID:        $TENANT_ID"
"AZURE_SUBSCRIPTION_ID:  $SUBSCRIPTION_ID"
"AZURE_CLIENT_ID_PROD:   $PROD_APP_ID"
"AZURE_CLIENT_ID_STG:    $STG_APP_ID"
