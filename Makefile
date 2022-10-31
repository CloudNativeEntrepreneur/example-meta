OS := $(shell uname)
LOCAL_DEV_CLUSTER ?= rancher-desktop
PROJECTS_TO_ONBOARD=apps/web3auth-service,apps/example-todo-model,apps/example-hasura-projections-service,apps/example-dead-letter-service,apps/sveltekit-web3auth-template
PROJECTS_TO_OPEN=apps/example-hasura,apps/web3auth-service,apps/example-todo-model,apps/example-hasura-projections-service,apps/example-dead-letter-service,apps/sveltekit-web3auth-template
GITOPS_REPO=https://github.com/CloudNativeEntrepreneur/example-gitops-local

delete-projects:
	meta exec "make delete-local-deployment" --include-only $(PROJECTS_TO_ONBOARD)

finish-onboard:
	@echo "✅ Onboard Complete. To complete development setup:\n\n1. Start localizer in a new window (\`sudo localizer\`) and leave it running. \n\n2. Run \`make open\` to open the projects to run locally. \n\n3. In each project(*), run \`make dev\` or use VSCode Debugger to start development mode with a debugger. \n\n\t* For \"example-hasura\", you can start the hasura console via the hasura CLI (\`hasura console\`)\n\t\t- see project's README for more details.\n\t* The VSCode Debugger is not supported for Sveltekit projects currently.\n\t\t- (https://github.com/CloudNativeEntrepreneur/sveltekit-web3auth/issues/6).\n\n"

hard-reset: destroy-local-dev-cluster update-meta-repos onboard

onboard: gitops-local onboard-projects finish-onboard

open:
	meta exec "make open" --include-only $(PROJECTS_TO_OPEN)

onboard-projects:
	meta exec "make onboard" --include-only $(PROJECTS_TO_ONBOARD)

rebase-master:
	meta exec "git fetch --all --tags -p && git rebase origin/master --autostash" --parallel

gitops-local: use-kube-local-dev
	@echo "🚀 Applying Gitops config..."

	# if env var GIT_TOKEN is not set, throw an error
	@if [ -z "${GIT_TOKEN}" ]; then \
		echo "GIT_TOKEN is not set. Please set it to your GitHub Personal Access Token. You can use this URL to generate the token: https://github.com/settings/tokens/new?scopes=repo"; \
		exit 1; \
	fi

	GIT_REPO=$(GITOPS_REPO) && \
	GIT_TOKEN=$(GIT_TOKEN) && \
	argocd-autopilot repo bootstrap --recover

use-kube-local-dev:
	kubectl ctx $(LOCAL_DEV_CLUSTER)

update-meta-repos:
	meta git update
