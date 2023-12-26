# Jenkins job to create a agent image

The purpose of this is to create an image that can be used as agent.

## How the Jenkins server is set up

The master has the label master.

Set the Jenkins Built-in node executor to Only jobs with label
expression matching this node.

## How to use this

Create agents with
Use this node as much as possible
Launch agent via execution of command on the controller
```
docker run --env DOCKER_HOST=tcp://docker:2376 --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 --volume jenkins-docker-certs:/certs/client:ro -i --rm myjenkinsagent:latest
```
