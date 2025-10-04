# === PROD AcrPull grant (AKS -> ACR) ===
$SUB      = "545d4a9b-b402-4493-a10a-99d17130d280"
$RG       = "prod-rgroup010"
$ACR_NAME = "prodacr010"
$AKS_NAME = "production-aks010"

az account set --subscription $SUB | Out-Null

# Resource IDs
$ACR_ID      = az acr show -n $ACR_NAME -g $RG --query id -o tsv
$KUBELET_OID = az aks show -g $RG -n $AKS_NAME --query identityProfile.kubeletidentity.objectId -o tsv


# Grant AcrPull to the AKS kubelet identity (runtime pull)
az role assignment create `
  --assignee-object-id $KUBELET_OID `
  --assignee-principal-type ServicePrincipal `
  --role "AcrPull" `
  --scope $ACR_ID

# Verify
az role assignment list --assignee $KUBELET_OID --scope $ACR_ID -o table
