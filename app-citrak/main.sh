#!/bin/sh
retval=0
exit_code=0

cd tfstate_resources
terraform init
terraform apply
cd ../deploy_app
terraform init
terraform apply
if [ $exit_code -ne 0 ]; then
    retval=$exit_code
fi

exit $retval
