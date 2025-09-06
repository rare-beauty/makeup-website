# For production ACR (when it exists)
az role assignment create --assignee dcf5697c-5814-4fcb-b2ed-9d20b703b742 --role AcrPush --scope /subscriptions/0aebd59b-0fa7-463c-b58d-3596e3b848ea/resourceGroups/prod-rg/providers/Microsoft.ContainerRegistry/registries/prodacr123
