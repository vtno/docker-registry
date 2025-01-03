#! /usr/bin/env bash

function enc() {
  prompt_if_file_exists registry_username.txt.enc
  prompt_if_file_exists registry_password_hash.txt.enc
  htpasswd -bnBC 10 "" $(cat registry_password.txt) | tr -d ':\n' > registry_password_hash.txt
  zypher encrypt -o registry_username.txt.enc -f registry_username.txt
  zypher encrypt -o registry_password_hash.txt.enc -f registry_password_hash.txt
}

function dec() {
  prompt_if_file_exists registry_username.txt
  prompt_if_file_exists registry_password_hash.txt
  zypher decrypt -o registry_username.txt -f registry_username.txt.enc
  zypher decrypt -o registry_password_hash.txt -f registry_password_hash.txt.enc
}

function prompt_if_file_exists() {
  if [ -f $1 ]; then
    read -p "File $1 already exists. Do you want to overwrite it? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      exit 1
    fi
  fi
}

function help() {
  echo "Usage: crypto.sh [enc|dec]"
}

if ! command -v zypher &> /dev/null; then
  echo "zypher is not installed. Please install it first with:"
  echo 'go install github.com/vtno/zypher/cmd/zypher@0.2.0'
  exit 1
fi

case $1 in
  enc)
    enc
    ;;
  dec)
    dec
    ;;
  *)
    help
    ;;
esac

exit 0
