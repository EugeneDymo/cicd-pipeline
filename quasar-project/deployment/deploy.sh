#!/bin/bash

set -x

# Thi script is executed from the project root folder (GitLab magic)
WORK_DIR="`pwd`"

# Apply environment
cat ${WORK_DIR}/.env.template | perl -wpne 's#\$\{?(\w+)\}?# $ENV{$1} // $& #ge;' 2>/dev/null> ${WORK_DIR}/.env
chmod +x ${WORK_DIR}/.env

set -a
. ${WORK_DIR}/.env

# Using docker to build our package in specific environment
docker build -f deployment/deployment-dockerfile -t ca_web_frontend ${WORK_DIR}
if [[ $? != "0" ]];then
    echo -e "\nERROR: There was an error during the frontend docker image's build.\n"
    exit 1;
fi

#docker run --rm ca_web_frontend npm run test
#
#if [[ $? != "0" ]];then
#    echo -e "\nERROR: There was an error during test execution.\n"
#    exit 1;
#fi

docker create -ti --name ca_web_frontend_container ca_web_frontend:latest bash
docker cp ca_web_frontend_container:/app/dist ${WORK_DIR}/dist
docker rm -f ca_web_frontend_container

# upload dist to S3
#aws s3 sync ${WORK_DIR}/dist/spa s3://$S3_BUCKET --acl public-read --delete --exclude ".env"
#aws cloudfront create-invalidation --distribution-id $CDN_DISTRIBUTION_ID --paths "/*"
