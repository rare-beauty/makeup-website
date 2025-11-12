# --- inputs ---
$SUB      = "4660c4f3-a83c-406e-8741-d1067921120b"
$RG       = "staging-rgroup02"
$AKS_NAME = "stage-aks02"
$ACR_NAME = "stagingacr02"

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
