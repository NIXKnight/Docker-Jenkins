# **Docker-Jenkins**

Dockerfile for Jenkins.

## **Usage**

Build the Docker image as follows:
```console
export JENKINS_LTS_VERSION="$(curl -L http://updates.jenkins-ci.org/stable/latestCore.txt)"
docker build . --file Dockerfile --build-arg JENKINS_VERSION=$JENKINS_LTS_VERSION --build-arg DOCKER_JENKINS_GROUP_ID=$(grep "^docker" /etc/group|cut -d: -f3) --tag jenkins:lts-$JENKINS_LTS_VERSION
```
Create a Docker volume for Jenkins:
```console
docker volume create jenkins_data
```
Run the container as follows:
```console
docker run -d --network host --restart=unless-stopped -v jenkins_data:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock --name jenkins jenkins:lts-$JENKINS_LTS_VERSION
```
After running the container, Jenkins will be available at http://localhost:8080.

## **License**

Licensed under MIT License (See the LICENSE file).

## **Author**

[Saad Ali](https://github.com/nixknight)
