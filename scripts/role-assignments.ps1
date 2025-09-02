$ORG = "rare-beauty"
$REPO = "makeup-website"
$SUBSCRIPTION_ID = "0aebd59b-0fa7-463c-b58d-3596e3b848ea"
$PROD_SP_OBJID = "af66834d-fd3e-48de-9194-5b3285ec837d"
$STG_SP_OBJID = "2febd9a3-9b0b-4f29-9f83-6ccdf4a7f27b"


# For PROD
az role assignment create `
  --assignee-object-id $PROD_SP_OBJID `
  --assignee-principal-type ServicePrincipal `
  --role "Storage Blob Data Contributor" `
  --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/tfstate-rg/providers/Microsoft.Storage/storageAccounts/tfstatestorage30aug"

# For STAGING
az role assignment create `
  --assignee-object-id $STG_SP_OBJID `
  --assignee-principal-type ServicePrincipal `
  --role "Storage Blob Data Contributor" `
  --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/tfstate-rg/providers/Microsoft.Storage/storageAccounts/tfstatestorage30aug"
