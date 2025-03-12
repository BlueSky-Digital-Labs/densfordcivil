#!/bin/bash

# Run with `sudo sh output-primary-key.sh`

if [ "$EUID" -ne 0 ]
    then echo "Run with sudo (root)."
    exit
fi

PRIVATE_KEY_FILE=primary.private
FORCE=0

# Reference: https://stackoverflow.com/questions/9271381/how-can-i-parse-long-form-arguments-in-shell
_setArgs(){
  while [ "${1:-}" != "" ]; do
    case "$1" in
      "--force" | "-f")
        FORCE=1
        ;;
    esac
    shift
  done
}

_main(){
  terraform output -raw primary-private-key > $PRIVATE_KEY_FILE
  chmod 400 $PRIVATE_KEY_FILE
  chown $SUDO_UID:$SUDO_GID $PRIVATE_KEY_FILE
  echo "Done."
}

_setArgs $*

# If $PRIVATE_KEY_FILE exists in directory
if ! [ -f $PRIVATE_KEY_FILE ]; then
  _main
elif [ $FORCE -eq 1 ] && [ -f $PRIVATE_KEY_FILE ]; then
  echo "WARNING: Force argument passed. Existing private key file will be deleted and recreated in five (5) seconds if you don't cancel it.";
  sleep 5;
  echo "Bye-bye private key file."
  rm $PRIVATE_KEY_FILE
  _main
else
    echo Primary Private Key exists. No action taken.
fi
