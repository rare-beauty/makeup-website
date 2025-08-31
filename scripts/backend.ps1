# backend.ps1  (PowerShell 5 or 7; Azure CLI installed)

param(
  [ValidateSet("staging","prod")]
  [string]$EnvName = "staging"
)

# ---- Globals ----
$ErrorActionPreference = "Continue"            # don't stop on native stderr
$env:PYTHONWARNINGS   = "ignore"               # mute az storage SDK warning

# Helper: run az, capture stderr, throw on non-zero exit
function AzQ {
  param([Parameter(Mandatory=$true, ValueFromRemainingArguments=$true)][string[]]$Args)
  $global:LASTEXITCODE = 0
  $out = & az @Args 2>&1
  $code = $LASTEXITCODE
  if ($code -ne 0) {
    $msg = ($out | Out-String)
    throw "az $($Args -join ' ') failed (exit $code)`n$msg"
  }
  return $out
}

# ---- Context (edit if needed) ----
$TENANT = "f1d37c2d-c0e1-4173-baf1-6bdc38f8bce8"
$SUB    = "0aebd59b-0fa7-463c-b58d-3596e3b848ea"

# ---- Backend resources ----
$ResourceGroupName   = "tfstate-rg"
$Location            = "eastus2"
$StorageAccountName  = "tfstatestorage30aug"   # must be globally unique, lowercase 3-24 chars
$ContainerName       = "tfstate"
$TfstateKey          = "$EnvName.terraform.tfstate"

# ---- Pin tenant & subscription ----
AzQ cloud set --name AzureCloud --only-show-errors | Out-Null
try { AzQ account show --only-show-errors | Out-Null } catch { AzQ login --tenant $TENANT --only-show-errors | Out-Null }
AzQ account set --subscription $SUB       | Out-Null
AzQ configure set defaults.subscription=$SUB | Out-Null

# ---- Resource Group (exists -> create) ----
$rgExists = (AzQ group exists -n $ResourceGroupName --subscription $SUB -o tsv).Trim()
if ($rgExists -ne "true") {
  AzQ group create -n $ResourceGroupName -l $Location --subscription $SUB --only-show-errors | Out-Null
}

# ---- Storage Account (exists -> create) ----
$saCount = (AzQ storage account list -g $ResourceGroupName --subscription $SUB `
            --query "[?name=='$StorageAccountName'] | length(@)" -o tsv).Trim()
if ($saCount -eq "0") {
  AzQ storage account create -n $StorageAccountName -g $ResourceGroupName -l $Location `
      --subscription $SUB --sku Standard_LRS --encryption-services blob --min-tls-version TLS1_2 `
      --only-show-errors | Out-Null
}

# ---- Account Key ----
$key = (AzQ storage account keys list -n $StorageAccountName -g $ResourceGroupName --subscription $SUB `
        --query "[0].value" -o tsv).Trim()
if ([string]::IsNullOrWhiteSpace($key)) { throw "Could not retrieve a storage account key." }

# ---- Container (exists -> create), using account key ----
$ctrExists = (AzQ storage container exists --name $ContainerName `
              --account-name $StorageAccountName --account-key $key `
              --query exists -o tsv).Trim()
if ($ctrExists -ne "true") {
  AzQ storage container create -n $ContainerName --account-name $StorageAccountName `
      --account-key $key --only-show-errors | Out-Null
}

# ---- Output ----
Write-Host ""
Write-Host "✅ Backend ready for environment: $EnvName" -ForegroundColor Green
Write-Host "   RG:        $ResourceGroupName"
Write-Host "   Storage:   $StorageAccountName"
Write-Host "   Container: $ContainerName"
Write-Host "   State key: $TfstateKey"
Write-Host ""
Write-Host "Add this to backend.tf for '$EnvName':"
Write-Host @"
terraform {
  backend "azurerm" {
    resource_group_name  = "$ResourceGroupName"
    storage_account_name = "$StorageAccountName"
    container_name       = "$ContainerName"
    key                  = "$TfstateKey"
  }
}
"@
