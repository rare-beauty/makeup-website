# === inputs (change RG if your ACR lives elsewhere) ===
#$SUB      = "545d4a9b-b402-4493-a10a-99d17130d280"
$SUB      = "4660c4f3-a83c-406e-8741-d1067921120b"
$RG       = "staging-rgroup02"                # ACR's resource group
$ACR_NAME = "stagingacr02"
#$STG_APPID  = "7e545c24-99fc-4ac5-8a03-a7916dde8bff"  # staging CI app (clientId)
$STG_APPID  = "53b0d08d-b186-40c2-8e4d-c9a3d3619e59"


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
