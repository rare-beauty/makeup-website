$SUB     = "4660c4f3-a83c-406e-8741-d1067921120b"   # Subscription ID
$STG_APP = "53b0d08d-b186-40c2-8e4d-c9a3d3619e59"   # AppId (ClientId) of staging SP

# Set subscription
az account set --subscription $SUB

# Get objectId of the service principal
$STG_OID = az ad sp list --filter "appId eq '$STG_APP'" --query "[0].id" -o tsv

# Assign User Access Administrator role at subscription scope
az role assignment create `
  --assignee-object-id $STG_OID `
  --role "User Access Administrator" `
  --scope "/subscriptions/$SUB"


# Note: reated it because your staging Terraform Service Principal (the one with AppId 53b0d08d-b186-40c2-8e4d-c9a3d3619e59)
# did NOT have enough permission to assign RBAC roles from your pipeline.
# Terraform needed to:
# assign ACR roles
# assign Key Vault data-plane roles
# assign subnet/NIC roles
# assign UAMI → Key Vault roles
# assign AKS → ACR pull role
# assign Gateway/Ingress roles
# assign Storage account roles