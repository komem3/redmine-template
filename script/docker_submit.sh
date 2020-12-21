#!/bin/bash

# Usage: ./jdocker_submit.sh $project_id

set -eux

cd `dirname $0`
cd ../

project=$1
hash=$(git hash-object ./docker/Dockerfile)

target="asia-northeast1-docker.pkg.dev/${project}/redmine-repo/redmine:${hash}"

gcloud auth configure-docker asia-northeast1-docker.pkg.dev

docker build ./docker -t ${target}

docker push ${target}
