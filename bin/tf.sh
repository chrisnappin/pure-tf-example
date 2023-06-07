#!/bin/sh

set -e

if [ $# -ne 3 ]
then
    echo "Selects the terraform workspace and runs the action, for the specified component and environment"
    echo "Usage: $0 <component> <environment> <action>"
    exit 1
fi

terraform -chdir="./components/$1" workspace select $2
echo "Using workspace `terraform -chdir="./components/$1" workspace show`"

terraform -chdir="./components/$1" $3 -var-file="../../config/$2.tfvars"
