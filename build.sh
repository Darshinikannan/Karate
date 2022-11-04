#!/bin/sh

# IMAGE_NAME="rest-assured-mvn"
# TEST_CMD="./mvn_runner.sh"
# DOCKER_FILE="Dockerfile.dev"
# MEMORY="500m"
# CPUS="1"

#Parsing key values from env.property file
ENV_VAR_FILE="env.property"
IMAGE_NAME=$(cat $ENV_VAR_FILE | grep 'runnerImageName' | cut -d '=' -f2- | tr -d '"')
BASE_IMAGE_NAME=$(cat $ENV_VAR_FILE | grep 'baseImageName' | cut -d '=' -f2- | tr -d '"')
BASE_IMAGE_VERSION=$(cat $ENV_VAR_FILE | grep 'baseImageVersion' | cut -d '=' -f2- | tr -d '"')
DOCKER_FILE=$(cat $ENV_VAR_FILE | grep 'dockerFilename' | cut -d '=' -f2- | tr -d '"')
MEMORY=$(cat $ENV_VAR_FILE | grep 'dockerMemory' | cut -d '=' -f2- | tr -d '"')
CPUS=$(cat $ENV_VAR_FILE | grep 'dockerCpus' | cut -d '=' -f2- | tr -d '"')
TEST_CMD=$(cat $ENV_VAR_FILE | grep 'runnerScript' | cut -d '=' -f2- | tr -d '"')
WORKING_DIR="/app"

if [ "$BASE_IMAGE_NAME" = "maven" ];then
    echo " copying Dockerfile.mvn to Dockerfile.dev"
    cp Dockerfile.mvn Dockerfile.dev -rf
fi
if [ "$BASE_IMAGE_NAME" = "cypress" ];then
    echo " copying Dockerfile.node to Dockerfile.dev"
    cp Dockerfile.node Dockerfile.dev -rf
fi

docker_image_creation() {
    #Below code is used for create docker image using $DOCKER_FILE with $IMAGE_NAME 
    docker build --build-arg IMAGE_NAME=$BASE_IMAGE_NAME --build-arg IMAGE_VERSION=$BASE_IMAGE_VERSION -f $DOCKER_FILE -t $IMAGE_NAME .
}

docker_run() {
    #Below Code is used for run vannila docker run command to execute created image
    docker run --rm -v "$PWD":"$WORKING_DIR" --env-file=$ENV_VAR_FILE --memory $MEMORY --cpus $CPUS -w $WORKING_DIR $IMAGE_NAME $TEST_CMD
}

docker_compose_run() {
    #Below Code is used for run vannila docker run command to execute created image
    docker compose build --build-arg IMAGE_NAME=$BASE_IMAGE_NAME --build-arg IMAGE_VERSION=$BASE_IMAGE_VERSION 
    docker compose up
}

docker_compose_down(){
    docker compose down
}

#Below code is used for create docker image using $DOCKER_FILE with $IMAGE_NAME 
if [ "$1" = "create-image" ];then
    docker_image_creation
fi

#Below Code is used for run vannila docker run command to execute created image
if [ "$1" = "run" ];then
    docker_run
fi


if [ "$1" = "compose-run" ];then
    docker_compose_run
fi

if [ "$1" = "compose-down" ];then
    docker_compose_down
fi

#Below code is used to do docker login for aws environment
if [ "$1" = "docker-login" ];then
    aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 619553686330.dkr.ecr.ap-south-1.amazonaws.com
fi


#Below code is used to retag and push image to Docker Repository
if [ "$1" = "retag-push" ];then
    docker tag $IMAGE_NAME:latest 619553686330.dkr.ecr.ap-south-1.amazonaws.com/$IMAGE_NAME:latest
    docker push 619553686330.dkr.ecr.ap-south-1.amazonaws.com/$IMAGE_NAME:latest
fi
