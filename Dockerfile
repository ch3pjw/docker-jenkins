FROM alpine
MAINTAINER Paul Weaver <paul.weaver@wipro.com>
# Heavily inspired by: https://github.com/cgswong/docker-jenkins/blob/master/1.625/Dockerfile

RUN apk add --no-cache openjdk8-jre

ENV JENKINS_VERSION 1.625
ENV JENKINS_HOME /opt/jenkins

RUN mkdir -p $JENKINS_HOME && \
    wget http://mirrors.jenkins-ci.org/war/$JENKINS_VERSION/jenkins.war \
      -O $JENKINS_HOME/jenkins.war

# FIXME: jenkins throws a null pointer exception without ttf-dejavu
RUN apk add --no-cache ttf-dejavu

ENV JENKINS_PERSISTENT /var/lib/jenkins
ENV JENKINS_USER jenkins
ENV JENKINS_GROUP jenkins

RUN addgroup $JENKINS_GROUP && \
    adduser -h $JENKINS_HOME -D -s /bin/sh -G $JENKINS_GROUP \
      $JENKINS_USER && \
    chown -R $JENKINS_USER:$JENKINS_GROUP $JENKINS_HOME

EXPOSE 8080 50000
VOLUME ["${JENKINS_PERSISTENT}"]

USER ${JENKINS_USER}
CMD java -jar ${JENKINS_HOME}/jenkins.war
