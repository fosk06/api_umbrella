.PHONY: help test
.SILENT: ;               # no need for @
.ONESHELL: ;             # recipes execute in same shell
.NOTPARALLEL: ;          # wait for this target to finish
.EXPORT_ALL_VARIABLES: ; # send all vars to shell


APP_NAME ?= `grep 'app:' mix.exs | sed -e 's/\[//g' -e 's/ //g' -e 's/app://' -e 's/[:,]//g'`
APP_VSN ?= `grep 'version:' mix.exs | cut -d '"' -f2`
# DOCKER_REGISTRY ?=`grep -w 'DOCKER_REGISTRY' .env | cut -d '=' -f2` 
# DOCKER_REGISTRY_USERNAME ?=`grep -w 'DOCKER_REGISTRY_USERNAME' .env | cut -d '=' -f2` 

## color variables 
Red=\033[0;31m
NC=\033[0m # No Color
Green=\033[0;32m
Blue=\033[0;36m


define my_test = 
	ls
endef

help:
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: commit_push ## Build the Docker image of the release
	@echo "$(Green)Build step ..........................................$(NC)"
	$(eval BUILD?=`git rev-parse --short HEAD`)
	$(eval DOCKER_TAG=$(APP_NAME):$(APP_VSN)-$(BUILD))
	$(eval REMOTE_DOCKER_TAG=$(DOCKER_REGISTRY)/$(DOCKER_USERNAME)/$(DOCKER_TAG))
	@echo "$(Blue)Image will have the following tags: $(DOCKER_TAG), $(REMOTE_DOCKER_TAG), $(APP_NAME):latest $(NC)"
	@docker build --build-arg APP_NAME=$(APP_NAME) \
		--build-arg APP_VSN=$(APP_VSN) \
		-t $(DOCKER_TAG) \
		-t $(REMOTE_DOCKER_TAG) \
		-t $(APP_NAME):latest .

run: build ## Run the release with docker, config/docker.env must be present and values set
	@echo "$(Green)Run step ..........................................$(NC)"
	docker run --env-file config/docker.env \
		--expose 4000 -p 4000:4000 \
		--rm -it $(APP_NAME):latest
		
run_stack: ## Run the stack with docker-compose, config/docker.env must be present and values set
	docker-compose up -d

stop_stack: ## Stop the stack with docker-compose
	docker-compose stop

commit_push: ## Commit and push code, DOCKER_REGISTRY,DOCKER_USERNAME,DOCKER_PASSWORD must be set in environment variables
	@echo "$(Green)Commit and Push step ...........................................$(NC)"
	git add .
	git commit
	git push origin master
	

push: build ## Build and push to docker registry
	@echo "$(Green)Push step ..........................................$(NC)"
	docker login $(DOCKER_REGISTRY) -p $(DOCKER_PASSWORD) -u $(DOCKER_USERNAME)
	@echo "push to $(REMOTE_DOCKER_TAG)"
	docker push $(REMOTE_DOCKER_TAG)

start: ## Get deps, compile and run locally with mix tasks, Elixir, node.js and phoenix must be installed to run localy.
	@echo "$(Green)Run local step ..........................................$(NC)"
	@echo "$(Red) elixir, node.js and phoenix must be installed first !$(NC)"
	@echo "$(Green) compile and run localy ........................ $(NC)"
	mix do deps.get, deps.compile, compile, phx.server

start_db: ## start db with docker
	docker-compose up -d db

start_interactive: ## start with interative terminal(iex)
	iex -S mix
	
reset_db: ## recreate database with tables and test data, use on development ONLY
	docker-compose up -d db
	## drop DB
	mix ecto.drop 
	## create DB
	mix ecto.create
	## run migrations, create tables
	mix ecto.migrate
	## seed tables with fake data
	mix run apps/db_connector/priv/repo/seeds.exs