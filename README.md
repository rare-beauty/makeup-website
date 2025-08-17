# 🧴✨ Beauty Micro‑services – Terraform & CI/CD Diary (16 Aug 2025)

<!-- Badges: point these to your real repository once it is hosted on GitHub -->
![Terraform CI](https://github.com/your-org/makeup-website/actions/workflows/terraform-pipeline.yaml/badge.svg)
![Docker CI](https://github.com/your-org/makeup-website/actions/workflows/arc-jfrog-push.yaml/badge.svg)

## Table of Contents

- [Current repository structure](#current-repository-structure)
- [What we did today](#what-we-did-today-16-aug-2025)
- [Infrastructure summary](#infrastructure-summary)
- [GitHub Actions pipelines](#github-actions-pipelines)
- [Notes and rationale](#notes-and-rationale)
- [Next steps](#next-steps)

## Current repository structure

The `makeup‑website` repository is organised into several high‑level folders.  A simplified view is shown below (folders end with `/`):

```
makeup‑website/
├── .github/
│   └── workflows/
│       ├── arc‑jfrog‑push.yaml
│       └── terraform‑pipeline.yaml
├── src/
│   ├── contact‑blog‑service/
│   ├── frontend/
│   ├── order‑service/
│   ├── product‑service/
│   ├── review‑service/
│   └── user‑service/
│       ├── docker‑compose.yml
│       └── README.md
├── terraform‑code/
│   └── environments/
│       ├── production/
│       │   ├── prod.tfvars
│       │   └── provider.tf
│       ├── staging/
│       │   ├── provider.tf
│       │   ├── staging.tfvars
│       │   ├── main.tf
│       │   ├── output.tf
│       │   └── variable.tf
│       ├── main.tf
│       ├── output.tf
│       └── variable.tf
├── .vscode/
├── .gitignore
└── README.md
```

The following diagram provides a visual representation of the same tree (generated from the repository at the time of writing):

![Repository tree diagram]({{file:file-BpkdYvFQzhRELwEYAUB8D6}})

## What we did today (16 Aug 2025)

### 1 • Created environment folders for Terraform

Within the **`terraform‑code/environments`** directory, two environment folders were created to separate configuration for production and staging:

| Environment | Purpose & files |
|---|---|
| **`production/`** | Contains `prod.tfvars` (variables specific to production) and `provider.tf` (provider configuration). |
| **`staging/`** | Contains `staging.tfvars`, plus its own `provider.tf`, `main.tf`, `output.tf` and `variable.tf`. |
| **Common files** | Outside of the two environment folders we keep **`main.tf`**, **`output.tf`** and **`variable.tf`**. These define modules and outputs shared by both environments. |

The new folders allow us to run separate Terraform plans for production and staging. Each environment can provide its own variables without duplicating the core module definitions.

### 2 • Defined infrastructure in `main.tf`

The shared `main.tf` defines a modular infrastructure for the project.  The high‑level resources include:

- **Resource Group:** defines the resource group for all Azure resources used by this project.
- **Virtual Network and subnets:** a VNet and subnets to host the AKS cluster and other services.
- **Azure Container Registry (ACR):** used to store container images.  The ACR module sets `admin_enabled = false` to disable the registry’s admin account.  Microsoft notes that the admin account is meant for single‑user testing; sharing the admin credentials with multiple users is not recommended【41616245198294†L94-L119】.  Instead, we rely on Microsoft Entra identities (service principals or managed identities) to access the registry.
- **Azure Key Vault:** used to store secrets such as database passwords.  The AKS cluster (or its managed identity) is assigned the **Key Vault Secrets User** role so it can read secret values【707466069183101†L140-L147】.
- **Azure Kubernetes Service (AKS) cluster:** hosts the micro‑services described in the `src/` folder.  The cluster’s kubelet identity is granted the **AcrPull** role, allowing the nodes to pull images from ACR【321986890093608†L404-L413】.  The cluster is also given the **Key Vault Secrets User** role as mentioned above.
- **RBAC assignments:** two role assignments are created in Terraform:
  1. **AcrPull:** grants the AKS cluster read‑only access to pull container images from the registry【321986890093608†L404-L413】.
  2. **Key Vault Secrets User:** allows the cluster to read secrets from Key Vault【707466069183101†L140-L147】.  Without this assignment the cluster would not be able to retrieve certificates or secrets.

By modularising the infrastructure and assigning only the minimum required roles, we reduce the attack surface while keeping the configuration DRY (Don’t Repeat Yourself).  Disabling the ACR admin user avoids accidental use of shared registry credentials【41616245198294†L94-L119】.

## Infrastructure summary

The following table summarises the main components defined in `main.tf`, their purpose and any noteworthy settings:

| Resource | Purpose | Key settings |
|---|---|---|
| **Resource group** | Logical container that holds all related Azure resources for the micro‑services. | Environment‑specific names (e.g., `rg-beauty-staging`, `rg-beauty-prod`). |
| **Virtual network & subnets** | Provide network isolation and connectivity for AKS, ACR and other services. | CIDR ranges parameterised per environment. |
| **Azure Container Registry (ACR)** | Stores container images built by the CI pipeline. | `admin_enabled = false` to disable the registry’s admin account【41616245198294†L94-L119】; uses managed identity for authentication. |
| **Azure Key Vault** | Securely stores secrets such as database credentials. | AKS identity is granted the **Key Vault Secrets User** role【707466069183101†L140-L147】. |
| **Azure Kubernetes Service (AKS) cluster** | Orchestrates the micro‑services defined in the `src/` folder. | Kubelet identity assigned **AcrPull** role to pull images from ACR【321986890093608†L404-L413】; cluster identity assigned **Key Vault Secrets User**. |
| **RBAC assignments** | Grant minimum privileges needed by AKS and other identities. | `AcrPull` role for image pulls【321986890093608†L404-L413】; `Key Vault Secrets User` to read secrets【707466069183101†L140-L147】. |

### 3 • Added GitHub Actions workflows

Under **`.github/workflows`** two CI/CD pipelines were added:

1. **`terraform‑pipeline.yaml`** – this workflow automates Terraform operations in the repository.  Its main features are:
   - **Terraform Format & Init:** runs `terraform fmt` and `terraform init` to format and initialise the working directory.
   - **Terraform Validate:** runs `terraform validate` against the environment specified by the workflow to catch syntax errors early.
   - **Terraform Plan:** runs `terraform plan -var‑file="<env>.tfvars"` to show proposed changes for the selected environment.  The `working‑directory` points to `terraform‑code/environments/${{steps.select-env.outputs.env}}`.
   - **Manual approval for production:** when changes are made on the `main` branch, the workflow pauses and uses the [`tstringer/manual-approval@v1`](https://github.com/marketplace/actions/manual-approval) action to require manual approval before applying changes to production.  This ensures that no unreviewed change is deployed to the live environment.
   - **Federated credentials:** the workflow is configured to use GitHub’s OpenID Connect (OIDC) integration to authenticate to Azure without storing long‑lived secrets.

2. **`arc‑jfrog‑push.yaml`** – this workflow builds and pushes Docker images.  Key points:
   - **Build & push for staging and production:** the workflow builds images using the micro‑services in `src/` and pushes them to the appropriate ACR (for staging or production) by using the `AcrPush` or `AcrPull` roles accordingly.
   - **SonarQube analysis:** before pushing, the workflow runs a SonarQube scan.  SonarQube is a static analysis tool that inspects source code for bugs, security vulnerabilities and code smells【571369797620274†L124-L134】.  Performing static analysis early in the pipeline helps catch issues before they reach production and reduces technical debt【571369797620274†L150-L160】.
   - **Multi‑environment tagging:** images are tagged with environment‑specific tags (e.g., `staging` or `production`) so deployments pull the correct version.

## GitHub Actions pipelines

Both workflows can be summarised at a glance:

| Workflow | Purpose | Key steps |
|---|---|---|
| **`terraform‑pipeline.yaml`** | Automates Terraform checks and planning for each environment. | Runs `terraform fmt` and `terraform init` (format and initialise), performs `terraform validate`, executes `terraform plan -var-file` targeting the selected environment, uses OIDC to authenticate with Azure, and pauses for manual approval on the `main` branch before applying changes. |
| **`arc‑jfrog‑push.yaml`** | Builds Docker images and pushes them to ACR for staging and production. | Builds each micro‑service in `src/`, performs a SonarQube scan to detect bugs and vulnerabilities【571369797620274†L124-L134】【571369797620274†L150-L160】, tags the images with environment‑specific tags, authenticates using `AcrPush`/`AcrPull` roles and pushes images to the appropriate container registry. |

## Notes and rationale

- **Disabling the ACR admin user:** According to Microsoft’s guidance, the admin account is intended for single‑user testing and should not be shared; instead, service principals or managed identities should be used【41616245198294†L94-L119】.  Setting `admin_enabled = false` enforces this best practice.
- **RBAC roles:** The `AcrPull` role allows our AKS cluster to pull images without granting unnecessary write permissions【321986890093608†L404-L413】, and `Key Vault Secrets User` lets it read secret values from Key Vault【707466069183101†L140-L147】.  Applying the principle of least privilege helps minimise security risks.
- **SonarQube:** Static code analysis catches bugs and vulnerabilities early in the development cycle, making fixes quicker and less costly【571369797620274†L124-L134】.  Integrating SonarQube into the CI pipeline ensures that every commit is checked for code quality and security issues【571369797620274†L150-L160】.

## Next steps

- **Add a development environment:** Consider adding a third environment (e.g., `dev/`) under `terraform‑code/environments` with its own variable file.  This will allow safe experimentation without affecting staging or production.
- **Automated deploy step:** Extend the `terraform‑pipeline.yaml` workflow with a `terraform apply` step that runs automatically for non‑production environments after plan succeeds.  For production, keep the manual approval.
- **Monitoring & logging:** Integrate Azure Monitor or Application Insights with AKS and ACR to gain visibility into cluster health and container registry metrics.
- **Secret rotation:** Implement periodic rotation of secrets stored in Key Vault and update the AKS cluster via the CSI driver or environment variable refresh.

This README captures the state of the repository and the work done on **16 Aug 2025**.  Future updates should add new sections as additional features or infrastructure are introduced.