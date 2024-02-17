#!/bin/bash

# Script to start and stop the jenkins container(s)
# This is normally run only to bootstrap the server
extraargsbuild=
extraargsrun=
case "$1" in
    update)
        docker stop jenkins
        docker stop jenkins-docker
        docker rm jenkins
        extraargsbuild="--pull"
        extraargsrun="--pull=always"
        ;&
    start)
        docker build $extraargsbuild . -t myjenkins:lts-jdk17
        docker run \
               --name jenkins-docker \
               $extraargsrun \
               --rm \
               --detach \
               --privileged \
               --network jenkins \
               --network-alias docker \
               --env DOCKER_TLS_CERTDIR=/certs \
               --volume jenkins-docker-certs:/certs/client \
               --volume jenkins-data:/var/jenkins_home \
               --publish 2376:2376 \
               docker:dind \
               --storage-driver overlay2
        sleep 5
        docker run \
               --name jenkins \
               --restart=on-failure \
               --detach \
               --network jenkins \
               --network-alias jenkins \
               --env DOCKER_HOST=tcp://docker:2376 \
               --env DOCKER_CERT_PATH=/certs/client \
               --env DOCKER_TLS_VERIFY=1 \
               --publish 8080:8080 \
               --publish 50000:50000 \
               --volume jenkins-data:/var/jenkins_home \
               --volume jenkins-docker-certs:/certs/client:ro \
               myjenkins:lts-jdk17
        docker exec jenkins-docker \
               docker run $extraargsrun --rm \
               -v maven-repo-matrix:/m \
               maven:3-ibmjava-8 chown 1000:1000 /m
        ;;
    stop)
        docker stop jenkins
        docker stop jenkins-docker
        ;;
    *)
        echo "Incorrect parameter $1" 1>&2
        exit 1;
    ;;
esac
