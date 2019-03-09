.PHONY: help

APP_NAME ?= `grep 'app:' mix.exs | sed -e 's/\[//g' -e 's/ //g' -e 's/app://' -e 's/[:,]//g'`
APP_VSN ?= `grep 'version:' mix.exs | cut -d '"' -f2`
BUILD ?= `git rev-parse --short HEAD`
# GIT_TAG = $(APP_VSN)-$(BUILD)
# DOCKER_REGISTRY ?=`grep -w 'DOCKER_REGISTRY' .env | cut -d '=' -f2` 
# DOCKER_REGISTRY_USERNAME ?=`grep -w 'DOCKER_REGISTRY_USERNAME' .env | cut -d '=' -f2` 
DOCKER_TAG = $(APP_NAME):$(APP_VSN)-$(BUILD)
DOCKER_TAG_REMOTE=$(DOCKER_REGISTRY)/$(DOCKER_USERNAME)/$(DOCKER_TAG)

## color variables 
Red=\033[0;31m
NC=\033[0m # No Color
Green=\033[0;32m
Blue=\033[0;36m

help:
	clear
	@echo "$(Red)Elixir, node.js and phoenix must be installed to run localy. $(NC)"
	@echo "$(Red)Don't forget to rename config/dockerenv to config/docker.env and set values.$(NC)"
	@echo "$(Green)DOCKER_TAG=$(DOCKER_TAG), DOCKER_TAG_REMOTE=$(DOCKER_TAG_REMOTE), DOCKER_REGISTRY=$(DOCKER_REGISTRY) $(NC)"
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: tag ## Build the Docker image of the release
	@echo "$(Green)Build step ..........................................$(NC)"
	@docker build --build-arg APP_NAME=$(APP_NAME) \
		--build-arg APP_VSN=$(APP_VSN) \
		-t $(DOCKER_TAG) \
		-t $(REMOTE_DOCKER_TAG) \
		-t $(APP_NAME):latest .

run: build ## Run the release with docker 
	@echo "$(Green)Run step ..........................................$(NC)"
	docker run --env-file config/docker.env \
		--expose 4000 -p 4000:4000 \
		--rm -it $(APP_NAME):latest
		
run_stack: ## Run the stack with docker-composes
	docker-compose up -d

stop_stack: ## Stop the stack with docker-compose
	docker-compose stop

tag: ## Create git tag and docker tag, commit and push with the tags
	@echo "$(Green)Tag step ...........................................$(NC)"
	git commit -a -m "release $(APP_VSN)"
	git push origin master
	$(eval BUILD?=`git rev-parse --short HEAD`)
	$(eval DOCKER_TAG=$(APP_NAME):$(APP_VSN)-$(BUILD))
	$(eval REMOTE_DOCKER_TAG=$(DOCKER_REGISTRY)/$(DOCKER_USERNAME)/$(DOCKER_TAG))
	@echo "$(Blue)DOCKER_TAG: $(DOCKER_TAG)$(NC)"
	@echo "$(Blue)REMOTE_DOCKER_TAG: $(REMOTE_DOCKER_TAG)$(NC)"

push: build ## Build and push to docker registry
	@echo "$(Green)Push step ..........................................$(NC)"
	@echo "$(Red)Don't forget to set DOCKER_REGISTRY,DOCKER_USERNAME,DOCKER_PASSWORD in env $(NC)"
	docker login $(DOCKER_REGISTRY) -p $(DOCKER_PASSWORD) -u $(DOCKER_USERNAME)
	@echo "push to $(REMOTE_DOCKER_TAG)"
	docker push $(REMOTE_DOCKER_TAG)

run_local: ## Get deps, compile and run locally with mix tasks
	@echo "$(Green)Run local step ..........................................$(NC)"
	@echo "$(Red) elixir, node.js and phoenix must be installed first !$(NC)"
	@echo "$(Green) compile and run localy ........................ $(NC)"
	mix do deps.get, deps.compile, compile, phx.digest, phx.server

test:
	export $$(ENV_FILE) && echo "$$DOCKER_REGISTRY"
	# @echo "$(Blue)$(ENV_FILE)$(NC)"
