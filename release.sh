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
az acr login --name geosentinel
# docker login geosentinel.azurecr.io -p <password> -u geosentinel

## build the image, commit and push to gihub with a tag
git add .
git commit -am "release $GITTAG"
git tag -a $GITTAG -m "release $GITTAG"
git push origin master
docker build --rm -f Dockerfile-phpapp -t $DOCKERIMAGE .
docker push $DOCKERIMAGE

## upgrade the release, if the relase has already been intalled
helm upgrade  --recreate-pods $RELEASENAME ./helm-chart

## install the release
# helm install  --name $RELEASENAME  ./helm-chart --namespace $NAMESPACE

## delete the release
# helm del --purge $RELEASENAME    