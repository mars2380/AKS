CREDS	:= .creds/.credential
USER	:= $(shell sed -n '1p' $(CREDS))
PASS	:= $(shell sed -n '2p' $(CREDS))

build: login check terraform
terraform: plan apply

login: clean
	az login -u $(USER) -p $(PASS)

check:
	az account set --subscription $(shell az account list --query "[?user.name=='$(USER)'].{Name:name, ID:id, Default:isDefault}" | jq .[].ID)
	export TF_VAR_resource_group=$(shell az group list | jq '.[].name' | sed 's/\"//g')

plan:
	terraform get && \
    terraform init && \
    terraform fmt -check && \
    terraform validate && \
    terraform plan

apply:
	terraform apply --auto-approve

clean:
	rm -rf .terraform || true
	rm *.tfstate || true
	rm *.tfstate.* || true