
$SUB = "545d4a9b-b402-4493-a10a-99d17130d280"
$LOC = "eastus"
$RG  = "rg-infra-staging"
$SA  = "infrastatestaging01"   # must be globally unique (lowercase, 3–24 chars)
$TENANT = "6006b17c-8ebf-4b58-b64f-d3db9972a6a7"

az login --tenant $TENANT | Out-Null

az account set --subscription $SUB

az group create -n $RG -l $LOC
az storage account create -n $SA -g $RG -l $LOC --sku Standard_LRS --kind StorageV2 
az storage container create --account-name $SA --name tfstate --auth-mode login 

# Print backend block
@"
terraform {
  backend "azurerm" {
    resource_group_name  = "$RG"
    storage_account_name = "$SA"
    container_name       = "tfstate"
    key                  = "infra/staging.tfstate"
  }
}
"@ | Write-Output
