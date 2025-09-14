$SUBSCRIPTION_ID = "0aebd59b-0fa7-463c-b58d-3596e3b848ea"
$STG_SP_OBJID  = "2febd9a3-9b0b-4f29-9f83-6ccdf4a7f27b"
$RG  = "staging-rg4"

az account set --subscription $SUBSCRIPTION_ID

# Grant permission to create role assignments
az role assignment create `
  --assignee-object-id $STG_SP_OBJID  `
  --assignee-principal-type ServicePrincipal `
  --role "User Access Administrator" `
  --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RG"