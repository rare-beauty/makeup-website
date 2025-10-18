# --- fill these ---
$SUB     = "545d4a9b-b402-4493-a10a-99d17130d280"
$RG      = "staging-rgroup010"
$KV      = "staging-010"
$STG_APP = "7e545c24-99fc-4ac5-8a03-a7916dde8bff"   # clientId (appId) of your staging CI SP

az account set --subscription $SUB
$STG_OID = az ad sp list --filter "appId eq '$STG_APP'" --query "[0].id" -o tsv

# Give JUST what's needed for role assignments:
# -- Key Vault scope (least privilege, recommended)
az role assignment create --assignee-object-id $STG_OID --role "User Access Administrator" --scope "/subscriptions/$SUB/resourceGroups/$RG/providers/Microsoft.KeyVault/vaults/$KV"

# (OR) Resource Group scope (broader; uncomment if you prefer)
# az role assignment create --assignee-object-id $STG_OID --role "User Access Administrator" --scope "/subscriptions/$SUB/resourceGroups/$RG"
