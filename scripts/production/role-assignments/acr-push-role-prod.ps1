# --- inputs (prod) ---
$SUB        = "545d4a9b-b402-4493-a10a-99d17130d280"
$RG         = "prod-rgroup010"
$ACR_NAME   = "prodacr010"
$PROD_APPID = "4fb5c823-3659-4a56-a2e3-d18987b247ae"   # prod CI SP (clientId)

az account set --subscription $SUB

# Resolve IDs
$PROD_SP_OID = az ad sp show --id $PROD_APPID --query id -o tsv
$ACR_ID      = az acr show -n $ACR_NAME -g $RG --query id -o tsv

# Grant **AcrPush** to CI identity
az role assignment create `
  --assignee-object-id $PROD_SP_OID `
  --assignee-principal-type ServicePrincipal `
  --role "AcrPush" `
  --scope $ACR_ID
