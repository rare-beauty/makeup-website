# init-backend.ps1
# PowerShell 7+, Azure CLI + Terraform installed

param(
  [ValidateSet("staging","prod")]
  [string]$EnvName = "staging"
)

# ==== Login to Azure ====
az login

# ==== Set variables ====
$resourceGroupName  = "tfstate-rg4"            # CHANGED (new RG name)
$location           = "eastus2"
$storageAccountName = "tfstate30sept123"       # SHORTENED to be valid (3–24 chars, lowercase/numbers)
$containerName      = "tfstate4"               # CHANGED (valid container name)
$tfstateKey         = "$EnvName.terraform.tfstate"  # not used below; kept for compatibility

# ==== Create backend infra (safe to run many times) ====
az group create --name $resourceGroupName --location $location

az storage account create `
  --name $storageAccountName `
  --resource-group $resourceGroupName `
  --location $location `
  --sku Standard_LRS `
  --encryption-services blob

# Use access key (more reliable than RBAC right after create)
$accountKey = az storage account keys list -g $resourceGroupName -n $storageAccountName --query "[0].value" -o tsv

az storage container create `
  --name $containerName `
  --account-name $storageAccountName `
  --account-key $accountKey | Out-Null

Write-Host "✅ Backend infra ready"
Write-Host "   RG:        $resourceGroupName"
Write-Host "   Storage:   $storageAccountName"
Write-Host "   Container: $containerName"

# ==== Create BOTH tfstate blobs by running terraform init in each env ====
$env:ARM_ACCESS_KEY = $accountKey

# STAGING -> staging.terraform.tfstate
terraform -chdir="C:\beauty\makeup-website\terraform-code\environments\staging" init -reconfigure `
  -backend-config="resource_group_name=$resourceGroupName" `
  -backend-config="storage_account_name=$storageAccountName" `
  -backend-config="container_name=$containerName" `
  -backend-config="key=staging.terraform.tfstate"

# PRODUCTION -> production.terraform.tfstate
terraform -chdir="C:\beauty\makeup-website\terraform-code\environments\production" init -reconfigure `
  -backend-config="resource_group_name=$resourceGroupName" `
  -backend-config="storage_account_name=$storageAccountName" `
  -backend-config="container_name=$containerName" `
  -backend-config="key=production.terraform.tfstate"

$env:ARM_ACCESS_KEY = ""

Write-Host "✅ Created state blobs: staging.terraform.tfstate + production.terraform.tfstate"
