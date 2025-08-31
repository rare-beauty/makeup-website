# init-backend.ps1
# PowerShell 7+, Azure CLI installed

param(
  [ValidateSet("staging","prod")]
  [string]$EnvName = "staging"
)

# ==== Login to Azure ====
az login

# ==== Set variables ====
$resourceGroupName  = "tfstate-rg"
$location           = "eastus2"
$storageAccountName = "tfstatestorage30aug"   # must be globally unique (all lowercase, 3-24 chars)
$containerName      = "tfstate"
$tfstateKey         = "$EnvName.terraform.tfstate"  # staging.terraform.tfstate or prod.terraform.tfstate

# ==== Create backend infra (safe to run many times) ====
az group create --name $resourceGroupName --location $location

az storage account create `
  --name $storageAccountName `
  --resource-group $resourceGroupName `
  --location $location `
  --sku Standard_LRS `
  --encryption-services blob

az storage container create `
  --name $containerName `
  --account-name $storageAccountName `
  --auth-mode login

Write-Host "✅ Backend ready for environment: $EnvName"
Write-Host "   RG:        $resourceGroupName"
Write-Host "   Storage:   $storageAccountName"
Write-Host "   Container: $containerName"
Write-Host "   State key: $tfstateKey"