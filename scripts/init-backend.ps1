# init-backend.ps1
# PowerShell 7+, Azure CLI installed
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true   # PS7+

$TENANT="f1d37c2d-c0e1-4173-baf1-6bdc38f8bce8"
$SUB   ="0aebd59b-0fa7-463c-b58d-3596e3b848ea"

az cloud set --name AzureCloud | Out-Null
try { az account show --only-show-errors | Out-Null } catch { az login --tenant $TENANT --only-show-errors | Out-Null }
az account set --subscription $SUB
az configure --defaults subscription=$SUB

param(
  [ValidateSet("staging","prod")]
  [string]$EnvName = "staging"
)

# ==== Login to Azure ====
# az login

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
