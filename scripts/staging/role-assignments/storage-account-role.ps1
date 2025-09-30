$SUB       = "545d4a9b-b402-4493-a10a-99d17130d280"
$STATE_RG  = "rg-infra-staging"        # backend RG (where the storage account lives)
$STATE_SA  = "infrastatestaging01"     # backend Storage Account
$STG_APP   = "7e545c24-99fc-4ac5-8a03-a7916dde8bff"  # staging app (clientId)

# Build the scope (storage account level)
$SA_ID = "/subscriptions/$SUB/resourceGroups/$STATE_RG/providers/Microsoft.Storage/storageAccounts/$STATE_SA"

# Get the Service Principal **objectId** for the app
$STG_OID = az ad sp show --id $STG_APP --query id -o tsv

# Assign the data-plane role
az role assignment create `
  --assignee-object-id $STG_OID `
  --assignee-principal-type ServicePrincipal `
  --role "Storage Blob Data Contributor" `
  --scope $SA_ID
