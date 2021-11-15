ARG JENKINS_VERSION
FROM jenkins/jenkins:${JENKINS_VERSION}-jdk11
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
    groupmod -g $DOCKER_JENKINS_GROUP_ID docker; \
    rm -rvf /var/lib/apt/lists/*
USER jenkins
COPY resources/plugins.txt /usr/share/jenkins/ref/plugins.txt
COPY resources/jcac.yaml /usr/share/jenkins/ref/jcac.yaml
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
ENV DOCKER_HOST unix:///var/run/docker.sock
ENV CASC_JENKINS_CONFIG /usr/share/jenkins/ref/jcac.yaml
