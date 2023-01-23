# Azure Container Moodle Instance

Template to deploy Moodle&trade; instance using [aci](https://azure.microsoft.com/pt-br/products/container-instances)

## Terraform Cloud Usage

1. Create organization at [terraform cloud](https://cloud.hashicorp.com/products/terraform);

1. Fork this repository;

1. Create a workspace and connect to repository specifying this folder as base directory;

1. Define the variables required by `hascorp/azurerm`:

```bash
ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"        # App Registration on Azure Active Directory
ARM_CLIENT_SECRET="<secret>"   # Client Secret at App Registration
```

1. Run Plan and Apply based on `main` branch.

## Local Usage

1. Install [Terraform CLI](https://developer.hashicorp.com/terraform/cli);

1. Clone this repository;

1. Access this folder;

1. Define the variables required by `hascorp/azurerm`:

```bash
export ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
export ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"        # App Registration on Azure Active Directory
export ARM_CLIENT_SECRET="<secret>"   # Client Secret at App Registration
```

1. Plan and Apply Terraform code.
