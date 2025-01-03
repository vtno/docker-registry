#! /usr/bin/env bash

function help() {
  echo "Usage: up.sh [user@ip-address] [domain]"
  echo "Example: up.sh tonytino@1.2.3.4"
  echo "The machine must have git, docker and docker compose installed."
}

if [ -z "$1" ] || [ -z "$2" ]; then
  help
  exit 1
fi

ssh_target=$1
domain=$2

echo "Cloning the repository on the remote machine..."
ssh -t "$ssh_target" 'git clone https://github.com/vtno/docker-registry.git ~/.docker-registry'
echo "Decrypting the registry credentials..."
./crypto.sh dec
echo "Copying the registry credentials to the remote machine..."
scp .env "$ssh_target:~/.docker-registry/"
echo "Starting the registry..."
ssh -t "$ssh_target" 'cd ~/.docker-registry && docker compose up -d'
echo "Health check..."

# loop until the registry is up for 10 seconds with 1 second pause
for i in {1..10}; do
  if curl -s -o /dev/null -w "%{http_code}" "https://$domain" | grep -q 200; then
    echo "Registry is up!"
    exit 0
  fi
  sleep 1
done

echo "Registry is not up. Please check the logs."
ssh -t "$ssh_target" 'cd ~/.docker-registry && docker compose logs'
exit 1
