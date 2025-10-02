# === inputs (change RG if your ACR lives elsewhere) ===
$SUB      = "545d4a9b-b402-4493-a10a-99d17130d280"
$RG       = "staging-rgroup010"                # ACR's resource group
$ACR_NAME = "stagingacr010"
$STG_APPID  = "7e545c24-99fc-4ac5-8a03-a7916dde8bff"  # staging CI app (clientId)

az account set --subscription $SUB

# Resolve IDs
$STG_ObjID = az ad sp show --id $STG_APPID --query id -o tsv
$ACR_ID  = az acr show --name $ACR_NAME --resource-group $RG --query id -o tsv

# CI (GitHub Actions SP) can push images
az role assignment create `
  --assignee-object-id $STG_ObjID `
  --assignee-principal-type ServicePrincipal `
  --role "AcrPush" `
  --scope $ACR_ID
