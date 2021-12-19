OS := $(shell uname)
LOCAL_DEV_CLUSTER ?= kind-local-dev-cluster
PROJECTS_TO_ONBOARD=projects/web3auth-db,projects/sourced-db,projects/example-readmodel-db,projects/example-hasura,projects/web3auth-service,projects/example-todo-model,projects/example-hasura-projections-service,projects/example-dead-letter-service,projects/sveltekit-web3auth
PROJECTS_TO_OPEN=projects/example-hasura,projects/web3auth-service,projects/example-todo-model,projects/example-hasura-projections-service,projects/example-dead-letter-service,projects/sveltekit-web3auth

delete-projects:
	meta exec "make delete-local-deployment" --include-only $(PROJECTS_TO_ONBOARD)

destroy-local-dev-cluster:
	cd tools/local-dev-cluster && make delete-cluster

finish-onboard:
	@echo "✅ Onboard Complete. To complete development setup:\n\n1. Start localizer in a new window (\`sudo localizer\`) and leave it running. \n\n2. Run \`make open\` to open the projects to run locally. \n\n3. In each project(*), run \`make dev\` or use VSCode Debugger to start development mode with a debugger. \n\n\t* For \"example-hasura\", you can start the hasura console via the hasura CLI (\`hasura console\`)\n\t\t- see project's README for more details.\n\t* The VSCode Debugger is not supported for Sveltekit projects currently.\n\t\t- (https://github.com/CloudNativeEntrepreneur/sveltekit-web3auth/issues/6).\n\n"

hard-refresh-local-images:
	kubectl ctx $(LOCAL_DEV_CLUSTER)
	meta exec "make hard-refresh-kind-image" --exclude "local-dev-cluster,web3auth-meta,example-hasura"

hard-reset: destroy-local-dev-cluster update-meta-repos onboard

localizer:
	sudo localizer

onboard: setup-local-dev-cluster onboard-projects finish-onboard

open:
	meta exec "make open" --include-only $(PROJECTS_TO_OPEN)

onboard-jx:
	jx ns jx

onboard-projects:
	meta exec "make onboard" --include-only $(PROJECTS_TO_ONBOARD)

rebase-master:
	meta exec "git fetch --all --tags -p && git rebase origin/master --autostash" --parallel

refresh-local-images:
	kubectl ctx $(LOCAL_DEV_CLUSTER)
	meta exec "make refresh-kind-image" --exclude "local-dev-cluster,web3auth-meta,example-hasura,example-readmodel" --parallel

setup-local-dev-cluster:
	cd tools/local-dev-cluster && make onboard

use-kube-local-dev:
	kubectl ctx $(LOCAL_DEV_CLUSTER)

update-meta-repos:
	meta git update
