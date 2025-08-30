$sp = az ad sp create-for-rbac --name "terraform" --role Contributor --scopes /subscriptions/0aebd59b-0fa7-463c-b58d-3596e3b848ea --output json | ConvertFrom-Json

# 1) Get the *Application* object ID for your app (not the SP object ID)
$APP_OBJECT_ID = az ad app show --id $($sp.appId) --query id -o tsv

# 2) Federated credential for the main branch
@"
{
  "name": "github-main",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "repo:rare-beauty/makeup-website.git:ref:refs/heads/main",
  "audiences": ["api://AzureADTokenExchange"],
  "description": "GitHub OIDC - main"
}
"@ | Set-Content fedcred-main.json -Encoding ASCII

az ad app federated-credential create `
  --id $APP_OBJECT_ID `
  --parameters @fedcred-main.json

# 3) Federated credential for the staging branch
@"
{
  "name": "github-staging",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "repo:rare-beauty/makeup-website.git:ref:refs/heads/staging",
  "audiences": ["api://AzureADTokenExchange"],
  "description": "GitHub OIDC - staging"
}
"@ | Set-Content fedcred-staging.json -Encoding ASCII

az ad app federated-credential create `
  --id $APP_OBJECT_ID `
  --parameters @fedcred-staging.json