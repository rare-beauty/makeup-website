# --- fill these ---
$SUB      = "4660c4f3-a83c-406e-8741-d1067921120b"
$STATE_RG = "rg-infras-staging"        # backend RG (where the storage account lives)
$STATE_SA = "infrastatestaging02"     # backend Storage Account
$STG_APP  = "53b0d08d-b186-40c2-8e4d-c9a3d3619e59"        # appId (clientId) of your staging CI SP

az account set --subscription $SUB
$STG_OID = az ad sp list --filter "appId eq '$STG_APP'" --query "[0].id" -o tsv

# 1) permission so TF can create the infra RG
az role assignment create --assignee-object-id $STG_OID --role "Contributor" --scope "/subscriptions/$SUB"

# Basically what i did in here:
#  az role assignment create `
#   --assignee-object-id 09c5db84-10fe-4144-9114-1922007fcce4 `
#   --role "Contributor" `
#   --scope "/subscriptions/545d4a9b-b402-4493-a10a-99d17130d280" `
#   --assignee-principal-type ServicePrincipal