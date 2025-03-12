#!/bin/bash

PROFILE=

VALIDATE_PASS=1

_setArgs()
{
  while [ "${1:-}" != "" ]; do
    case "$1" in
      "--profile")
        shift
        PROFILE=$1
        ;;
    esac
    shift
  done
}

_validate()
{
  if [ -z "${PROFILE}" ]; then
    VALIDATE_PASS=0
    echo "Error: profile must be set (e.g.: --profile iam-profile)"
  fi

  if [ $VALIDATE_PASS = 0 ]; then
    exit 1
  fi
}

_setArgs $*
_validate

aws s3api list-buckets \
  --profile $PROFILE \
  --output table \
  --query "Buckets[].Name"