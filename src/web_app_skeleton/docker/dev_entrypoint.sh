#!/bin/bash

set -euo pipefail

# This is the entrypoint script used for development docker workflows. By
# default it will:
#  - Install shards.
#  - Run migrations.
#  - Start the dev server.
# It also accepts any commands to be run instead.


warnfail () {
  echo "$@" >&2
  exit 1
}

case ${1:-} in
  "") # If no arguments are provided, start lucky dev server.
    ;;

  *) # If any arguments are provided, execute them instead.
    exec "$@"
esac

echo "Installing npm packages..."
npm install

if ! shards check ; then
  echo "Installing shards..."
  shards install
fi

echo "Waiting for postgres to be available..."
./docker/wait-for-it.sh postgres:5432

echo "Starting lucky dev server..."
exec lucky dev || warnfail "Lucky dev server failed."
