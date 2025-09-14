$SUBSCRIPTION_ID = "0aebd59b-0fa7-463c-b58d-3596e3b848ea"
$PROD_SP_OBJID   = "af66834d-fd3e-48de-9194-5b3285ec837d"  # prod SP objectId
$PROD_RG         = "prod-rg4"                              # your prod RG

az account set --subscription $SUBSCRIPTION_ID

# Grant permission to create role assignments
az role assignment create `
  --assignee-object-id $PROD_SP_OBJID `
  --assignee-principal-type ServicePrincipal `
  --role "User Access Administrator" `
  --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$PROD_RG"
