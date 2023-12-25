FROM jenkins/jenkins:lts-jdk17
USER root
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli
USER jenkins
WORKDIR /var/jenkins_agent
ADD --chown=jenkins:jenkins \
    http://jenkins:8080/jnlpJars/agent.jar \
    /var/jenkins_agent/agent.jar
RUN chmod +x agent.jar
ENTRYPOINT java -jar agent.jar
