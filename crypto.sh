#! /usr/bin/env bash

function enc() {
  prompt_if_file_exists .env.enc
  zypher encrypt -o .env.enc -f .env
}

function dec() {
  prompt_if_file_exists .env
  zypher decrypt -o .env -f .env.enc
}

function hash() {
  htpasswd -bnBC 10 "" "$1" | tr -d ':\n'
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
  echo "Usage: crypto.sh [enc|dec|hash] [plain-password]"
  echo "Example: crypto.sh enc"
  echo "Example: crypto.sh dec"
  echo "Example: crypto.sh hash mypassword"
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
  hash)
    hash $2
    ;;
  *)
    help
    ;;
esac

exit 0
