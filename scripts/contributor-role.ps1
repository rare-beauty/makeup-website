# Staging
az role assignment create `
  --assignee-object-id 2febd9a3-9b0b-4f29-9f83-6ccdf4a7f27b `
  --assignee-principal-type ServicePrincipal `
  --role "Contributor" `
  --scope "/subscriptions/0aebd59b-0fa7-463c-b58d-3596e3b848ea/resourceGroups/staging-rg4"

# Production
az role assignment create `
  --assignee-object-id af66834d-fd3e-48de-9194-5b3285ec837d `
  --assignee-principal-type ServicePrincipal `
  --role "Contributor" `
  --scope "/subscriptions/0aebd59b-0fa7-463c-b58d-3596e3b848ea/resourceGroups/prod-rg4"
