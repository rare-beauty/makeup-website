# --- fill these ---
$SUB      = "545d4a9b-b402-4493-a10a-99d17130d280"
$STATE_RG = "rg-infra-staging"        # backend RG (where the storage account lives)
$STATE_SA = "infrastatestaging01"     # backend Storage Account
$STG_APP  = "7e545c24-99fc-4ac5-8a03-a7916dde8bff"        # appId (clientId) of your staging CI SP

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