CREDS		:= .creds/.credential
USER		:= $(shell sed -n '1p' $(CREDS))
PASS		:= $(shell sed -n '2p' $(CREDS))
GROUP_LIST	:= $(shell az group list | jq '.[].name' | sed 's/\"//g')
FILE_PLAN	:= tfplan

build: login check terraform
terraform: init plan apply

login:
	az login -u "$(USER)" -p "$(PASS)"

check:
	az account set --subscription $(shell az account list --query "[?user.name=='$(USER)'].{Name:name, ID:id, Default:isDefault}" | jq .[].ID)

init:
	terraform init && \
    terraform fmt && \
    terraform validate

plan:
	export TF_VAR_resource_group=$(GROUP_LIST) && \
	terraform plan -out=$(FILE_PLAN)

apply:
	terraform apply --auto-approve $(FILE_PLAN)

clean:
	rm -rf .terraform* || true
	rm *.tfstate || true
	rm *.tfstate.* || true
	rm tfplan || true