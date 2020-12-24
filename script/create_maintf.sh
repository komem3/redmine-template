#!/bin/bash

# ./create_maintf.sh $project_id

cd `dirname $0`
cd ../

project=$1

sed -e "s/{project_id}/${project}/g" ./main.tf.template > main.tf
