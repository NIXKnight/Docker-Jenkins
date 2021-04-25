ARG JENKINS_VERSION
FROM jenkins/jenkins:${JENKINS_VERSION}-lts-jdk11
ARG DOCKER_JENKINS_GROUP_ID
ENV DOCKER_JENKINS_GROUP_ID $DOCKER_JENKINS_GROUP_ID
USER root
RUN set -eux; \
    apt-get update; \
    apt-get -y install --no-install-recommends gnupg-agent software-properties-common; \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - ; \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo $ID) $(lsb_release -cs) stable"; \
    apt-get update; \
    apt-get -y install --no-install-recommends docker-ce; \
    curl -L "https://github.com/docker/compose/releases/download/$(git ls-remote --tags "https://github.com/docker/compose" | awk '{print $2}' | grep -v '{}' | awk -F"/" '{print $3}' | sort -n -t. -k1,1 -k2,2 -k3,3 | tail -n 1)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose; \
    chmod +x /usr/local/bin/docker-compose; \
    usermod -a -G docker jenkins; \
    rm -rvf /var/lib/apt/lists/*
USER jenkins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
