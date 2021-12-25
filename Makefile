CREDS	:= .creds/.credential
USER	:= $(shell sed -n '1p' $(CREDS))
PASS	:= $(shell sed -n '2p' $(CREDS))

build: login terraform
terraform: plan apply

login:
	az login -u $(USER) -p $(PASS)

check:
	az account set --subscription $(shell az account list --query "[?user.name=='$(USER)'].{Name:name, ID:id, Default:isDefault}" | jq .[].ID)

plan:
	terraform get && \
    terraform init && \
    terraform fmt -check && \
    terraform validate && \
    terraform plan

apply:
	terraform apply --auto-approve

#terraform import azurerm_resource_group.example /subscriptions/0f39574d-d756-48cf-b622-0e27a6943bd2/resourceGroups/example