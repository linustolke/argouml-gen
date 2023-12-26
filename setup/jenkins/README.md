# How to configure Jenkins

If there are details that does not fit into the jobs-configurion.

## Run jenkins

Docker command
```
  docker run -p 8080:8080 -p 50000:50000 --restart=on-failure \
      -v jenkins_home:/var/jenkins_home \
      jenkins/jenkins:lts-jdk17
```
