$SUB = "0aebd59b-0fa7-463c-b58d-3596e3b848ea"
$RG  = "staging-rg4"
$AKS = "stage-aks"
$ACR = "stagingacr947"

az account set --subscription $SUB

# Get kubelet managed identity (AAD object id) and ACR scope
$KUBELET_OID = az aks show -g $RG -n $AKS --query "identityProfile.kubeletidentity.objectId" -o tsv
$ACR_SCOPE   = az acr show -n $ACR --query id -o tsv

# Give pull rights
az role assignment create `
  --assignee-object-id $KUBELET_OID `
  --assignee-principal-type ServicePrincipal `
  --role AcrPull `
  --scope $ACR_SCOPE

# Verify
az role assignment list --assignee-object-id $KUBELET_OID --scope $ACR_SCOPE -o table --all
