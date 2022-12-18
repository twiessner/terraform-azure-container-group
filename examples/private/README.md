
# Introduction

# Initialization

## Terraform

### Setup

```bash
export ARM_TENANT_ID="<your Azure tenat id>"
export ARM_SUBSCRIPTION_ID="<your Azure subscription id>"
```

### Lifecycle init

```bash
terraform init -upgrade
```

### Lifecycle apply

```bash
terraform apply
```

### Lifecycle cleanup

```bash
terraform destroy
```
