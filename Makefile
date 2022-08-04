CREDS			:= .creds/.credential
USER			:= $(shell sed -n '1p' $(CREDS))
PASS			:= $(shell sed -n '2p' $(CREDS))
GROUP_LIST		:= $(shell az group list | jq '.[].name' | sed 's/\"//g')
CLUSTER_NAME	:= $(shell az aks list | jq '.[].name' | sed 's/\"//g')
FILE_PLAN		:= tfplan

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

connect: check
	az aks get-credentials --resource-group $(GROUP_LIST) --name $(CLUSTER_NAME)
	kubectl config current-context
	kubectl config use-context $(CLUSTER_NAME)

kube-config-check:
	kubectl config get-clusters | grep $(CLUSTER_NAME) || true
	kubectl config get-contexts | grep $(CLUSTER_NAME) || true
	kubectl config get-users | grep $(CLUSTER_NAME) || true

kube-config-clean:
	kubectl config delete-cluster $(CLUSTER_NAME) || true
	kubectl config delete-context $(CLUSTER_NAME) || true
	kubectl config delete-user $(shell kubectl config get-users | grep $(CLUSTER_NAME)) || true

create-cluster:
	time az aks create \
		--resource-group $(GROUP_LIST) \
		--name myAKSCluster \
		--node-count 2