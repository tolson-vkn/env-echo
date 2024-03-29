TAG=$(shell git log --pretty=format:'%h' -n 1)
REGISTRY=timmyolson/env-echo
PROVIDER=docker.io
MAKE_DIR=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

.PHONY: help
help:

	@echo "+------------------+"
	@echo "| env-echo targets |"
	@echo "+------------------+"
	@grep -E '^[a-zA-Z\-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-12s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build: ## Build env-echo locally

	docker build -t env-echo ./flask

.PHONY: dev
dev: ## Start dev env-echo container

	docker run --rm -i -t \
		--name env-echo \
		-v $(MAKE_DIR)/flask/app:/app \
		-v $(MAKE_DIR)/flask/requirements.txt:/requirements.txt \
		-e DEBUG=True \
		-p 5000:5000 \
		env-echo 

.PHONY: shell
shell: ## Start a /bin/bash shell on env-echo container

	docker run --rm -i -t \
		--name env-echo \
		-v $(MAKE_DIR)/flask/app:/app \
		-v $(MAKE_DIR)/flask/requirements.txt:/requirements.txt \
		-e DEBUG=True \
		-p 5000:5000 \
		--entrypoint=/bin/bash \
		env-echo 

.PHONY: up
up: ## Start immutable env-echo container

	docker run --name env-echo \
		--rm -i -t \
		-p 5000:5000 \
		env-echo:latest

.PHONY: exec
exec: ## Exec /bin/bash into running env-echo

	docker exec -i -t env-echo bash

.PHONY: watch
watch: ## Start a watch commmand

	watch -n 0 'docker ps --format "table {{.ID}}\t{{.Command}}\t\t{{.Status}}\t{{.Ports}}\t{{.Names}}"'

.PHONY: login
login: ## Log into registry

	docker login $(PROVIDER)

.PHONY: publish
publish: ## Build locally and publish to registry

	@printf '\033[33mBuild and Push env-echo\033[0m\n';
	docker build -t env-echo:$(TAG) ./flask
	docker tag env-echo:$(TAG) $(REGISTRY):$(TAG)
	docker push $(REGISTRY):$(TAG)

	@printf '\033[33mUpdate the latest tag to $(TAG)\033[0m\n';
	docker tag env-echo:$(TAG) $(REGISTRY):latest
	docker push $(REGISTRY):latest

.PHONY: deploy
deploy: ## Deploy env-echo to Kuberentes

	@printf '\033[33mBuild and Push env-echo\033[0m\n';
	kubectl apply -f k8s/

.PHONY: gen-version
gen-version: ## Replace k8s deploy image:tag to current git commit

	@printf '\033[33mModifying image from:\033[0m\n';
	@grep '\- image:' ./k8s/env-echo-deploy.yaml
	@printf '\033[33mTo current git commit [$(TAG)]\033[0m\n';
	sed -i 's/^      - image: .*$$/      - image: timmyolson\/env-echo:$(TAG)/' ./k8s/env-echo-deploy.yaml
