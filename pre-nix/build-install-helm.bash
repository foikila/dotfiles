#/bin/bash

# Copyright (c) 2020 Jonatan Karlsson. All rights reserved.
#
# This work is licensed under the terms of the MIT license.  
# For a copy, see <https://opensource.org/licenses/MIT>.

#
# Simple script that builds a Spring-application and deploys
# it to an local instance of minikube.
#


RUNNING="ok"
NAME=`ls chart/ | sed 's:/*$::'` 
TAG=`date +%s`
IMAGE="$NAME:$TAG"
NAMESPACE="tse"
VALUES="chart/$NAME/minikube-values.yaml"

function run() {
    echo -e ""
    echo -e "[RUNNING COMMAND]: \e[32m$@\e[0m" 
    echo -e ""
    $@ || exit
}

function minikube-attach() {
    echo "Setting the necessary environment variables"
    # Add NO_PROXY for Minikube unless already present
    if [[ $(echo $NO_PROXY) != *",$(minikube ip)"* ]]; then
        export NO_PROXY=$NO_PROXY,$(minikube ip)
    fi
    # Only add if no_proxy exists and not already contain Minikube's ip
    if [ ! -z ${no_proxy+x} ] && [[ $(echo $no_proxy) != *",$(minikube ip)"* ]]; then
        export no_proxy=$no_proxy,$(minikube ip)
    fi
    eval $(minikube docker-env)
    export MINIKUBE_DOCKER_ENV_UNSET=$(minikube docker-env --unset)
    export MINIKUBE_IP_UNSET=",$(minikube ip)"
}

# Check if minikube is running
minikube status > /dev/null 2>&1 || RUNNING="not-running"
if [[ "$RUNNING" == "not-running" ]]; then
    echo "Minikube is not running, starting it"

    minikube-start
fi

# Make sure we're attached
minikube-attach

# Use minikubes values file if it exist
if [ -f "$VALUES" ]; then
    FCOMMAND="-f $VALUES"
fi

# Make sure we have latest base-chart provided by 3PP
run helm dependency update chart/$NAME

# Build the spring-app
run mvn clean package

# Package the spring-app into a docker image
run docker build . -t $IMAGE

# Deploying the service into local running minikube
run helm upgrade --install --namespace $NAMESPACE $NAME chart/$NAME/ --set global.ci.image=$IMAGE $FCOMMAND

