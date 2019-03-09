.PHONY: help

APP_NAME ?= `grep 'app:' mix.exs | sed -e 's/\[//g' -e 's/ //g' -e 's/app://' -e 's/[:,]//g'`
APP_VSN ?= `grep 'version:' mix.exs | cut -d '"' -f2`
BUILD ?= `git rev-parse --short HEAD`
GIT_TAG = $(APP_VSN)-$(BUILD)
DOCKER_TAG = $(APP_NAME):$(GIT_TAG)-$(BUILD)
RED='\033[0;31m'
NC='\033[0m' # No Color

help:
	@echo "$(DOCKER_TAG)"
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: release ## Build the Docker image
	@echo "build step..................................."
	docker build --build-arg APP_NAME=$(APP_NAME) \
		--build-arg APP_VSN=$(APP_VSN) \
		-t $(APP_NAME):$(APP_VSN)-$(BUILD) \
		-t $(APP_NAME):latest .

run: build ## run and build image 
	@echo -e "${RED}run step..................................."
	docker run --env-file config/docker.env \
		--expose 4000 -p 4000:4000 \
		--rm -it $(APP_NAME):latest
		
run_stack: ## Run the stack
	docker-compose up -d

stop_stack: ## Stop the stack
	docker-compose stop

release: ## Release
	@echo "${RED}release step...................................${NC}"
	git commit -a -m "release $(GIT_TAG)"
	git tag -a $(GIT_TAG) -m "release $(GIT_TAG)"
	git push origin master
	$(eval BUILD?=`git rev-parse --short HEAD`)
	$(eval GIT_TAG=$(APP_VSN)-$(BUILD))
	$(eval DOCKER_TAG=$(APP_NAME):$(GIT_TAG)-$(BUILD))
	@echo "BUILD $(BUILD)"
	@echo "GIT_TAG $(GIT_TAG)"
	@echo "DOCKER_TAG $(DOCKER_TAG)"