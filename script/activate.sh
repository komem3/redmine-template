#!/bin/bash

# usage:
# ./activate.sh $project_id $service_account

set -eux

cd `dirname $0`
cd ../

if [ ! -e ./sensitive.tfvars ]; then
  cp ./sensitive.tfvars.template ./sensitive.tfvars
fi

gcloud services enable container.googleapis.com
gcloud services enable sqladmin.googleapis.com
gcloud services enable iamcredentials.googleapis.com
gcloud services enable servicenetworking.googleapis.com
gcloud services enable cloudkms.googleapis.com
gcloud services enable artifactregistry.googleapis.com
gcloud services enable file.googleapis.com
