# AKS
# Deploy AKS cluster
```bash
make build
```
### Available Commands
<details>
  <summary>Usage Makefile - Click to expand</summary>

|Command|Description|
|---|---|
|`make build`|Deploy ASK Cluster|
|`make login`|Login to AKS CLI|
|`make check`|Set account|
|`make terraform`|Deploy terraform config|
|`make init`|Initialiaze, format and validate Terraform config|
|`make plan`|Plan Terraform config|
|`make apply`|Apply Terraform config|
|`make clean`|Clean Terraform config|

### Example

#### Deploy to AKS
```bash
make clean
make build
```

</details>

#### Couchbase
`https://docs.couchbase.com/operator/current/tutorial-aks.html`

#### ToDo
* Create AKS terraform configuration - Done
* Create Github actions to deploy AKS - Done
* Create cluster with `aks` command and connect - Done
* Create Gitops deployment


