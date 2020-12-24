#!/bin/bash

# ./activate.sh $project_id

set -eux

project=$1

cd `dirname $0`
cd ../

if [ ! -e ./sensitive.tfvars ]; then
  cp ./sensitive.tfvars.template ./sensitive.tfvars
fi

if [ ! -e ./docker/configuration.yml ]; then
  cp ./docker/configuration.yml.template ./docker/configuration.yml
fi

gcloud services enable container.googleapis.com --project $project
gcloud services enable sqladmin.googleapis.com --project $project
gcloud services enable iamcredentials.googleapis.com --project $project
gcloud services enable servicenetworking.googleapis.com --project $project
gcloud services enable cloudkms.googleapis.com --project $project
gcloud services enable artifactregistry.googleapis.com --project $project
gcloud services enable file.googleapis.com --project $project

gsutil mb gs://$project-tf-state

./script/create_maintf.sh $project
