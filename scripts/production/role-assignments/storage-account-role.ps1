$SUB       = "4660c4f3-a83c-406e-8741-d1067921120b"
$STATE_RG  = "rg-infras-staging"        # backend RG (where the storage account lives)
$STATE_SA  = "infrastatestaging02"     # backend Storage Account
$Prod_APP = "ba3891bd-8a09-4e26-b09a-8d58a5661a95"

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