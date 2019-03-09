.PHONY: help

APP_NAME ?= `grep 'app:' mix.exs | sed -e 's/\[//g' -e 's/ //g' -e 's/app://' -e 's/[:,]//g'`
APP_VSN ?= `grep 'version:' mix.exs | cut -d '"' -f2`
BUILD ?= `git rev-parse --short HEAD`
GIT_TAG = $(APP_VSN)-$(BUILD)
DOCKER_TAG = $(APP_NAME):$(GIT_TAG)-$(BUILD)
## color variables 
Red=\033[0;31m
NC=\033[0m # No Color
Green=\033[0;32m
Blue=\033[0;36m

help:
	clear
	@echo "$(Red)Elixir, node.js and phoenix must be installed to run localy. $(NC)"
	@echo "$(Red)Don't forget to rename config/dockerenv to config/docker.env and set values.$(NC)"
	@echo "current docker tag : $(DOCKER_TAG)"
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: release ## Build the Docker image of the release
	@echo "$(Green)build step ..........................................$(NC)"
	docker build --build-arg APP_NAME=$(APP_NAME) \
		--build-arg APP_VSN=$(APP_VSN) \
		-t $(APP_NAME):$(APP_VSN)-$(BUILD) \
		-t $(APP_NAME):latest .

run: build ## Run the release with docker 
	@echo "$(Green)run step ..........................................$(NC)"
	docker run --env-file config/docker.env \
		--expose 4000 -p 4000:4000 \
		--rm -it $(APP_NAME):latest
		
run_stack: ## Run the stack with docker-compose
	docker-compose up -d

stop_stack: ## Stop the stack with docker-compose
	docker-compose stop

release: ## Commit and push the new release
	@echo "$(Green)release step ..........................................$(NC)"
	git commit -a -m "release $(GIT_TAG)"
	git tag -a $(GIT_TAG) -m "release $(GIT_TAG)"
	git push origin master
	$(eval BUILD?=`git rev-parse --short HEAD`)
	$(eval GIT_TAG=$(APP_VSN)-$(BUILD))
	$(eval DOCKER_TAG=$(APP_NAME):$(GIT_TAG)-$(BUILD))
	@echo "$(Blue)DOCKER_TAG: $(DOCKER_TAG)$(NC)"

push: ## push to docker registry
	@echo "$(Green)push step ..........................................$(NC)"
	export $$(cat .env | grep -v ^\# | xargs) && docker login $$DOCKER_REGISTRY -p $$DOCKER_REGISTRY_PASSWORD -u $$DOCKER_REGISTRY_USERNAME
	export $$(cat .env | grep -v ^\# | xargs) && docker tag ${DOCKER_TAG} "$$DOCKER_REGISTRY/$$DOCKER_REGISTRY_USERNAME/${DOCKER_TAG}"
	# export $$(cat .env | grep -v ^\# | xargs) && docker push "$$DOCKER_REGISTRY/$$DOCKER_REGISTRY_USERNAME/${DOCKER_TAG}"

run_local: ## Get deps, compile and run locally with mix tasks
	@echo "$(Red) elixir, node.js and phoenix must be installed first !$(NC)"
	@echo "$(Green) compile and run localy ........................ $(NC)"
	mix do deps.get, deps.compile, compile, phx.digest, phx.server
