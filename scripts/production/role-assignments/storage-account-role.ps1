$SUB       = "545d4a9b-b402-4493-a10a-99d17130d280"
$STATE_RG  = "rg-infra-staging"        # backend RG (where the storage account lives)
$STATE_SA  = "infrastatestaging01"     # backend Storage Account
$Prod_APP = "4fb5c823-3659-4a56-a2e3-d18987b247ae"

# Build the scope (storage account level)
$SA_ID = "/subscriptions/$SUB/resourceGroups/$STATE_RG/providers/Microsoft.Storage/storageAccounts/$STATE_SA"

# Get the Service Principal **objectId** for the app
$PROD_OID = az ad sp show --id $Prod_APP --query id -o tsv

# Assign the data-plane role
az role assignment create `
  --assignee-object-id $PROD_OID `
  --assignee-principal-type ServicePrincipal `
  --role "Storage Blob Data Contributor" `
  --scope $SA_ID