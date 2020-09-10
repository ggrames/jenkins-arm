#!/bin/bash

PREFIX="grames.ddns.net"
VERSION=2.256

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
RESOURCEDIR="$BASEDIR/resources"

if [ ! -d "$RESOURCEDIR" ]; then
  mkdir $RESOURCEDIR && cd $RESOURCEDIR
  curl -sSLk -o tini https://github.com/krallin/tini/releases/download/v0.13.0/tini-static-armhf
  curl -sSLO https://raw.githubusercontent.com/jenkinsci/docker/master/init.groovy
  curl -sSLO https://raw.githubusercontent.com/jenkinsci/docker/master/jenkins.sh
  curl -sSLO https://raw.githubusercontent.com/jenkinsci/docker/master/install-plugins.sh
  curl -sSLO https://raw.githubusercontent.com/jenkinsci/docker/master/plugins.sh
  curl -sSLO https://raw.githubusercontent.com/jenkinsci/docker/master/jenkins-support
  chmod +rx *
  cd $BASEDIR
fi

docker build --rm --no-cache -t $PREFIX/jenkins-arm:$VERSION .
docker tag $PREFIX/jenkins-arm:$VERSION $PREFIX/jenkins-arm:latest

docker push $PREFIX/jenkins-arm:$VERSION
docker push $PREFIX/jenkins-arm:latest
