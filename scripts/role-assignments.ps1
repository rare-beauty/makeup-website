# NEW backend
$SUBSCRIPTION_ID = "0aebd59b-0fa7-463c-b58d-3596e3b848ea"
$NEW_RG = "tfstate-rg4"
$NEW_SA = "tfstate30sept123"
$NEW_CN = "tfstate4"

# Your SP object IDs (you already have these)
$PROD_SP_OBJID = "af66834d-fd3e-48de-9194-5b3285ec837d"
$STG_SP_OBJID  = "2febd9a3-9b0b-4f29-9f83-6ccdf4a7f27b"

# (Recommended) scope to the CONTAINER — least privilege for tfstate
$SCOPE = "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$NEW_RG/providers/Microsoft.Storage/storageAccounts/$NEW_SA/blobServices/default/containers/$NEW_CN"

az role assignment create --assignee-object-id $PROD_SP_OBJID --assignee-principal-type ServicePrincipal --role "Storage Blob Data Contributor" --scope $SCOPE
az role assignment create --assignee-object-id $STG_SP_OBJID  --assignee-principal-type ServicePrincipal --role "Storage Blob Data Contributor" --scope $SCOPE


