# --- inputs  ---
$SUB       = "4660c4f3-a83c-406e-8741-d1067921120b"   # <-- ensure this is the PROD subscription
$Prod_APP  = "ba3891bd-8a09-4e26-b09a-8d58a5661a95"   # PROD CI SP (clientId)

# Set context
az account set --subscription $SUB

# Resolve the Service Principal OBJECT ID for the PROD app
$PROD_OID = az ad sp show --id $Prod_APP --query id -o tsv

# 1) Give Contributor at SUBSCRIPTION scope (so TF can create RGs, etc.)
az role assignment create `
  --assignee-object-id $PROD_OID `
  --assignee-principal-type ServicePrincipal `
  --role "Contributor" `
  --scope "/subscriptions/$SUB"
