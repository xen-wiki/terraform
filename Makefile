.PHONY: ssh-application help export-ips rsync-application tunnel-application

-include Makefile.env

# Use 'make export-ips' before doing anything else

help:
	@echo "Available targets:"
	@echo "  make export-ips       - Get connection details from Terraform and configure Makefile.env"
	@echo "  make ssh-application  - SSH to application host"
	@echo "  make rsync-application SRC=<file> [DEST=<path>] - Copy files to/from application host"
	@echo "  make tunnel-application - SSH tunnel to dev nginx (local 443 -> remote 8443)"

export-ips:
	@echo "Exporting IPs from Terraform state..."
	@echo "APPLICATION_IP := $$(terraform output -raw application_ip)" > Makefile.env
	@echo "SSH_PORT := $$(terraform output -raw ssh_port)" >> Makefile.env
	@echo "SSH_USER := $$(terraform output -raw ssh_user)" >> Makefile.env
	@echo "IPs and database host exported to Makefile.env"

ssh-application:
	@echo "Connecting to application at $(APPLICATION_IP):$(SSH_PORT)..."
	@ssh -p $(SSH_PORT) $(SSH_USER)@$(APPLICATION_IP)

rsync-application:
	@if [ -z "$(SRC)" ]; then \
		echo "Error: SRC parameter is required"; \
		echo "Usage: make rsync-application SRC=<file> [DEST=<path>]"; \
		exit 1; \
	fi
	@DEST_PATH=$(if $(DEST),$(DEST),$(notdir $(SRC))); \
	echo "Syncing $(SRC) to $(SSH_USER)@$(APPLICATION_IP):$$DEST_PATH..."; \
	rsync -avz -e "ssh -p $(SSH_PORT)" $(SRC) $(SSH_USER)@$(APPLICATION_IP):$$DEST_PATH

tunnel-application:
	@sudo ssh -i ~/.ssh/id_rsa -N -L 443:localhost:8443 -p $(SSH_PORT) $(SSH_USER)@$(APPLICATION_IP)
