$SUB       = "4660c4f3-a83c-406e-8741-d1067921120b"
$STATE_RG  = "rg-infras-staging"        # backend RG (where the storage account lives)
$STATE_SA  = "infrastatestaging02"     # backend Storage Account
$STG_APP   = "53b0d08d-b186-40c2-8e4d-c9a3d3619e59"  # staging app (clientId)

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
