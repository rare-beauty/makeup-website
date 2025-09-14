# ==== Vars (STAGING) ====
$SUB = "0aebd59b-0fa7-463c-b58d-3596e3b848ea"
$RG  = "staging-rg4"
$AKS = "stage-aks"
$ACR = "stagingacr947"

az account set --subscription $SUB

# 1) Get kubelet objectId and ACR scope (resource ID)
$KUBELET = az aks show -g $RG -n $AKS --query identityProfile.kubeletidentity.objectId -o tsv
$SCOPE   = az acr show -g $RG -n $ACR --query id -o tsv

# 2) Find existing AcrPull assignment ID at that scope
$ASSIGN_ID = az role assignment list --assignee $KUBELET --role "AcrPull" --scope $SCOPE --query "[0].id" -o tsv
$ASSIGN_ID
