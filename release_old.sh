#!/bin/bash

# each release is bound to one image tag of the project 
# first of all , update the image->tag version in the ./helm-chart/values.yaml file
# get values from the Yaml values.yml file
TAG=$(yaml get ./helm-chart/values.yaml image.tag)
SERVICENAME=$(yaml get ./helm-chart/values.yaml fullnameOverride)
REPOSITORY=$(yaml get ./helm-chart/values.yaml image.repository)
DOCKERIMAGE="$REPOSITORY:$TAG"
GITTAG="$SERVICENAME-$TAG"

## the kubernetes namespace, set "production" for production env, or "staging" for staging
NAMESPACE=production

## the release name
RELEASENAME="$SERVICENAME-$NAMESPACE"

## login to azure docker registry, you can user the docker login command instead
# docker login registry -p <password> -u user

## build the image, commit and push to gihub with a tag
npm run build:prod
git add .
git commit -am "release $GITTAG"
git tag -a $GITTAG -m "release $GITTAG"
git push origin master
docker build --rm -f Dockerfile -t $DOCKERIMAGE .
docker push $DOCKERIMAGE

## upgrade the release, if the relase has already been intalled
helm upgrade  --recreate-pods $RELEASENAME ./helm-chart

## install the release
# helm install  --name $RELEASENAME  ./helm-chart --namespace $NAMESPACE

## delete the release
# helm del --purge $RELEASENAME

# grep 'DOCKER_REGISTRY' .env | cut -d '=' -f2


# @echo "$(Green)push step ..........................................$(NC)"
	# $(eval BUILD?=`git rev-parse --short HEAD`)
	# $(eval GIT_TAG=$(APP_VSN)-$(BUILD))
	# $(eval DOCKER_TAG=$(APP_NAME):$(GIT_TAG))
	# # @echo "$(Blue)DOCKER_TAG: $(DOCKER_TAG)$(NC)"
	# export $$(cat .env | grep -v ^\# | xargs) && docker login $$DOCKER_REGISTRY -p $$DOCKER_REGISTRY_PASSWORD -u $$DOCKER_REGISTRY_USERNAME
	# export $$(cat .env | grep -v ^\# | xargs) && docker tag $(DOCKER_TAG) "$$DOCKER_REGISTRY/$$DOCKER_REGISTRY_USERNAME/$(DOCKER_TAG)"
	# # @export $$(cat .env | grep -v ^\# | xargs) &&  echo "$$DOCKER_REGISTRY/$$DOCKER_REGISTRY_USERNAME/${DOCKER_TAG}"
	# export $$(cat .env | grep -v ^\# | xargs) && docker push "$$DOCKER_REGISTRY/$$DOCKER_REGISTRY_USERNAME/${DOCKER_TAG}"
