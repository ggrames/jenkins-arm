    #!/bin/bash

    PREFIX="myname"
    VERSION=2.256
    IMAGE="jenkins-arm"

    BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    RESOURCEDIR="$BASEDIR/resources"

    if [ ! -d "$RESOURCEDIR" ]; then
      mkdir $RESOURCEDIR && cd $RESOURCEDIR
      curl -sSLk -o tini https://github.com/krallin/tini/releases/download/v0.19.0/tini-static-armhf
      curl -sSLO https://raw.githubusercontent.com/jenkinsci/docker/master/tini-shim.sh
      curl -sSLO https://raw.githubusercontent.com/jenkinsci/docker/master/jenkins.sh
      curl -sSLO https://raw.githubusercontent.com/jenkinsci/docker/master/install-plugins.sh
      curl -sSLO https://raw.githubusercontent.com/jenkinsci/docker/master/plugins.sh
      curl -sSLO https://raw.githubusercontent.com/jenkinsci/docker/master/jenkins-support
      curl -sSLO https://raw.githubusercontent.com/jenkinsci/docker/master/jenkins-plugin-cli.sh
      chmod +rx *
      cd $BASEDIR
    fi

    docker build -t $PREFIX/$IMAGE:$VERSION .
    docker tag $PREFIX/$IMAGE:$VERSION $PREFIX/$IMAGE:latest 
    docker tag $PREFIX/$IMAGE:$VERSION docker.io/ggrames/$IMAGE:$VERSION

    docker push $PREFIX/$IMAGE:$VERSION
    docker push $PREFIX/$IMAGE:latest
    docker push docker.io/ggrames/$IMAGE:$VERSION
