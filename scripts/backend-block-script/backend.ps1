
$SUB = "4660c4f3-a83c-406e-8741-d1067921120b"
$LOC = "eastus"
$RG  = "rg-infras-staging"
$SA  = "infrastatestaging02"   # must be globally unique (lowercase, 3–24 chars)
$TENANT = "82168e20-b2fb-4b5b-92ff-91df15b0de08"

az login --tenant $TENANT | Out-Null

az account set --subscription $SUB

az group create -n $RG -l $LOC
az storage account create -n $SA -g $RG -l $LOC --sku Standard_LRS --kind StorageV2 
az storage container create --account-name $SA --name tfstate --auth-mode login 

# default to "staging" unless you pass an arg like "production"
$EnvName = if ($args.Count -gt 0) { $args[0] } else { "staging" }
# Print backend block
@"
terraform {
  backend "azurerm" {
    resource_group_name  = "$RG"
    storage_account_name = "$SA"
    container_name       = "tfstate"
    key                  = "infra/$EnvName.tfstate"
  }
}
"@ | Write-Output
