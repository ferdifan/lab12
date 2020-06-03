REPO = ${HOME}/repositories/2u/uci/uci-irv-cyber-pt-03-2020-u-c/Week-12-Cloud-Security/Resources/terraform/

.PHONY: azurecli
azurecli: mkdirs
	which az || bin/setup_az.sh
	az --version

.PHONY: terraform
terraform: mkdirs
	which terraform || bin/setup_tf.sh
	#ls ${TF_file} && bin/setup_tf.sh
	terraform version

.PHONY: az_login
az_login: mkdirs
	az login | tee /home/kali/.uci/az/login

.PHONY: account_list
account_list: mkdirs
	az account list --query "[].{name:name, subscriptionId:id, tenantId:tenantId}" | tee ${HOME}/.uci/az/account_list

.PHONY: subscribe
subscribe: account_list
	bin/subscribe.sh
.PHONY: vars
vars: mkdirs
	bin/setvars.sh

#.PHONY: clean
#clean:  rm


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  Move or copy terraform config files into deployment directory.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Make the temporary directories if they don't already exist.
.PHONY: mkdirs
mkdirs:
	ls ${HOME}/.uci/az || mkdir -p ${HOME}/.uci/az

# Create the deployment directory if not already exists.
.PHONY: mkdeploydir
mkdeploydir:
	ls -d ~/my_az_deployment || mkdir ~/my_az_deployment

# Copy the Makefile from the repository to the deployment directory.
.PHONY: copy_makefile
copy_makefile: mkdeploydir
	cp ${REPO}/Makefile ~/my_az_deployment/.

# Copy the setup script from the repository to the deployment directory.
.PHONY: copy_setup
copy_setup: copy_makefile
	cp ${REPO}/RedTeam/setup.sh ~/my_az_deployment/.

# Copy the vars file from the repostiroty to the deployment directory.
.PHONY: copy_vars
copy_vars: copy_setup
	cp ${REPO}/RedTeam/*-vars.tf ~/my_az_deployment/.

# Copy the main.tf from the repository to the deployment directory.
.PHONY: copy_main
copy_main: copy_vars
	cp ${REPO}/RedTeam/main.tf ~/my_az_deployment/.

# Copy the network 1 config file from the repository to the deployment directory.
.PHONY: copy_network-1-1
copy_network-1-1: copy_main
	cp ${REPO}/RedTeam/network-1.tf ~/my_az_deployment/.

# Copy the network 1 overlay file from the repository to the deployment directory.
.PHONY: copy_network-1-2
copy_network-1-2: copy_main
	cp ${REPO}/RedTeam/network-1-overlay.tf ~/my_az_deployment/network-1.tf

# Copy the network 2 files from the repository to the deployment directory.
.PHONY: copy_subnet-webtier
copy_subnet-webtier: copy_network-1-2
	cp ${REPO}/RedTeam/subnet-webtier.tf ~/my_az_deployment/.

# Copy the red team security group config file from the repository to the deployment directory.
#.PHONY: copy_redteamsg
#copy_redteamsg: copy_network-1-2
#	cp ${REPO}/Week-12-Cloud-Security/Resources/terraform/RedTeam/RedTeam-SG.tf ~/my_az_deployment/.

# Copy the virtual machine 1 config files from the repository to the deployment directory.
.PHONY: copy_vm-1
copy_vm-1: copy_subnet-webtier
	cp ${REPO}/RedTeam/vm-1.tf ~/my_az_deployment/.
	cp ${REPO}/RedTeam/cloud-init-1.txt ~/my_az_deployment/.
	#base64 ~/my_az_deployment/cloud-init-1.txt > cloud-init-1.b64

# Copy the virtual machine 1 config files from the repository to the deployment directory.
.PHONY: copy_vm-2
copy_vm-2: copy_vm-1
	cp ${REPO}/RedTeam/vm-2.tf ~/my_az_deployment/.
	cp ${REPO}/RedTeam/cloud-init-2.txt ~/my_az_deployment/.
	#base64 ~/my_az_deployment/cloud-init-2.txt > cloud-init-2.b64

.PHONY: deploy_ansible_key
deploy_ansible_key:
	scp ~/.ssh/id_vm2 ${jumpbox_ip}:.ssh/id_rsa

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  terraform commands
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Initialize terraform config.
.PHONY: init
init:
	. ./setup.sh ; terraform init

# Run the terraform plan.
.PHONY: plan
plan:
	. ./setup.sh ; terraform plan --out "plan.out"

# Run a terraform plan to destroy the environment.
.PHONY: destroy
destroy:
	. ./setup.sh ; terraform plan -destroy --out "plan.out"

# Apply the terraform plan to build or destroy resources.
.PHONY: apply
apply:
	. ./setup.sh ; terraform apply "plan.out"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  The following is used by Korben to sync the local repo to the server where
#  the virtual machines are running.  It synchronizes only the changed files.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Apply the terraform plan to build or destroy resources.
.PHONY: sync_repo
sync_repo:
	rsync -zavh ~/repositories/ lab01:repositories