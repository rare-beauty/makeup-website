# --- inputs ---
$SUB      = "545d4a9b-b402-4493-a10a-99d17130d280"
$RG       = "staging-rgroup010"
$AKS_NAME = "stage-aks010"
$ACR_NAME = "stagingacr010"

az account set --subscription $SUB

# IDs
$ACR_ID      = az acr show -n $ACR_NAME -g $RG --query id -o tsv
$KUBELET_OID = az aks show -g $RG -n $AKS_NAME --query identityProfile.kubeletidentity.objectId -o tsv

# Grant AcrPull to the kubelet identity
az role assignment create `
  --assignee-object-id $KUBELET_OID `
  --assignee-principal-type ServicePrincipal `
  --role "AcrPull" `
  --scope $ACR_ID
