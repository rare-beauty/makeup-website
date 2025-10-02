# --- inputs  ---
$SUB       = "545d4a9b-b402-4493-a10a-99d17130d280"   # <-- ensure this is the PROD subscription
$Prod_APP  = "4fb5c823-3659-4a56-a2e3-d18987b247ae"   # PROD CI SP (clientId)

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
