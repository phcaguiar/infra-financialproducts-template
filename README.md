# Product Infrastructure Repository

This repo holds automation scripts to provision *Product*.

See the `Product.description.yaml` file for a summary about the product.

This repo was based on the
[infra-financialproducts-template](https://github.com/stone-payments/infra-financialproducts-template)
repo. See the docs/README.md there for information about these repos' organizational structure.

**You should adapt this README** to match your own product. We suggest you update and mantain in this README at least the sections presented here, and you can add other as you wish.

### IaC Softwares Versions

- Terraform >= `0.12.4`
- Azure Provider >= `1.31.0`
- Ansible >= `2.8`

### Pipeline Status

| Product  | Build |  Staging Release | Disaster Recovery Release | Production Release
| ----- | ----- | ---- | ---- | ---- |
| Baseline  | [![Build status](https://stonepagamentos.visualstudio.com/finprods-tribe/_apis/build/status/FinancialProducts-Infra-Baseline-CI)](https://stonepagamentos.visualstudio.com/finprods-tribe/_build/latest?definitionId=1398) | ![aa](https://stonepagamentos.vsrm.visualstudio.com/_apis/public/Release/badge/4dabbf23-040c-444d-b88d-e742c1967066/4/9) | ![](https://stonepagamentos.vsrm.visualstudio.com/_apis/public/Release/badge/4dabbf23-040c-444d-b88d-e742c1967066/4/10) | ![](https://stonepagamentos.vsrm.visualstudio.com/_apis/public/Release/badge/4dabbf23-040c-444d-b88d-e742c1967066/4/11) |

### Application DNS Address

- App1: **app1.dns.com.br**
- App2: **app2.dns.com.br**