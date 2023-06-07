#!/bin/sh

set -e

if [ $# -ne 3 ]
then
    echo "Initialises s3 remote state backend and terraform workspace, for the specified component and environment"
    echo "Usage: $0 <component> <environment> <backend>"
    exit 1
fi

terraform -chdir="./components/$1" init -backend-config="../../config/$3.s3.tfbackend"

terraform -chdir="./components/$1" workspace new $2
