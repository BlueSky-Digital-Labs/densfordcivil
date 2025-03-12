#!/bin/bash

PROFILE=
BUCKET_NAME=
REGION=

VALIDATE_PASS=1

_setArgs(){
  while [ "${1:-}" != "" ]; do
    case "$1" in
      "--profile")
        shift
        PROFILE=$1
        ;;
      "--region")
        shift
        REGION=$1
        ;;
      "--bucket")
        shift
        BUCKET_NAME=$1
        ;;
    esac
    shift
  done
}

_validate(){
  if [ -z "${PROFILE}" ]; then
    VALIDATE_PASS=0
    echo "Error: profile must be set (e.g.: --profile iam-profile)"
  fi
  
  if [ -z "${BUCKET_NAME}" ]; then
    VALIDATE_PASS=0
    echo "Error: bucket name must be set (e.g.: --bucket new-bucket)"
  fi
  
  if [ -z "${REGION}" ]; then
    echo "Region (--region) is not set but will default to ap-southeast-2"
    REGION=ap-southeast-2
  fi

  if [ $VALIDATE_PASS = 0 ]; then
    exit 1
  fi
}

_setArgs $*
_validate

aws s3api delete-bucket \
  --profile $PROFILE \
  --bucket $BUCKET_NAME \
