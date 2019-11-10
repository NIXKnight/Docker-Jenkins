FROM jenkins/jenkins:lts-jdk11

USER root
RUN apt-get update && apt-get -y dist-upgrade && apt-get install -y git python python3 virtualenv python3-virtualenv python3-dev build-essential libmariadbclient-dev libffi-dev libssl-dev
USER jenkins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
